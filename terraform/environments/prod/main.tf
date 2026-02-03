provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "upstash" {
  email   = var.upstash_email
  api_key = var.upstash_api_key
}

# =============================================================================
# GCP APIs (must be enabled before creating any resources)
# =============================================================================

module "apis" {
  source = "../../modules/shared/apis"

  project_id = var.project_id
}

# =============================================================================
# Shared Infrastructure
# =============================================================================

module "networking" {
  source = "../../modules/shared/networking"

  project_id = var.project_id
  region     = var.region

  depends_on = [module.apis]
}

module "database" {
  source = "../../modules/shared/database"

  project_id = var.project_id
  region     = var.region
  tier       = var.database.tier
  disk_size  = var.database.disk_size
  disk_type  = var.database.disk_type

  private_network        = module.networking.vpc_self_link
  private_vpc_connection = module.networking.private_vpc_connection

  depends_on = [module.apis, module.networking]
}

module "redis" {
  source = "../../modules/shared/redis"

  project_id     = var.project_id
  name           = "primind-redis"
  primary_region = var.redis.primary_region
  tls            = var.redis.tls
  eviction       = var.redis.eviction

  depends_on = [module.apis]
}

module "artifact_registry" {
  source = "../../modules/shared/artifact-registry"

  project_id = var.project_id
  location   = var.region

  depends_on = [module.apis]
}

module "notification_invoker" {
  source = "../../modules/services/notification-invoker"

  project_id            = var.project_id
  region                = var.region
  artifact_registry_url = module.artifact_registry.repository_url
  image_tag             = var.services.notification_invoker.image_tag
  min_instances         = var.services.notification_invoker.min_instances
  max_instances         = var.services.notification_invoker.max_instances
  cpu                   = var.services.notification_invoker.cpu
  memory                = var.services.notification_invoker.memory
  web_app_url           = var.web_app_url

  depends_on = [module.artifact_registry]
}

module "time_mgmt" {
  source = "../../modules/services/time-mgmt"

  project_id            = var.project_id
  region                = var.region
  artifact_registry_url = module.artifact_registry.repository_url
  vpc_connector_id      = module.networking.vpc_connector_id
  image_tag             = var.services.time_mgmt.image_tag
  min_instances         = var.services.time_mgmt.min_instances
  max_instances         = var.services.time_mgmt.max_instances
  cpu                   = var.services.time_mgmt.cpu
  memory                = var.services.time_mgmt.memory

  # Database
  sql_instance_name   = module.database.instance_name
  database_private_ip = module.database.private_ip
  database_name       = var.services.time_mgmt.database.name
  database_user       = var.services.time_mgmt.database.user

  depends_on = [module.database, module.artifact_registry, module.networking]
}

module "throttling" {
  source = "../../modules/services/throttling"

  project_id            = var.project_id
  region                = var.region
  artifact_registry_url = module.artifact_registry.repository_url
  vpc_connector_id      = module.networking.vpc_connector_id
  image_tag             = var.services.throttling.image_tag
  min_instances         = var.services.throttling.min_instances
  max_instances         = var.services.throttling.max_instances
  cpu                   = var.services.throttling.cpu
  memory                = var.services.throttling.memory

  # Redis
  redis_host           = module.redis.host
  redis_port           = module.redis.port
  redis_auth_secret_id = module.redis.auth_secret_id
  redis_tls_enabled    = module.redis.tls_enabled

  # Inter-service dependencies
  notification_invoker_url          = module.notification_invoker.service_url
  notification_invoker_service_name = module.notification_invoker.service_name
  time_mgmt_url                     = module.time_mgmt.service_url
  time_mgmt_service_name            = module.time_mgmt.service_name
  remind_events_topic_id            = module.time_mgmt.pubsub_topic_id

  depends_on = [module.notification_invoker, module.time_mgmt, module.redis]
}

module "central_backend" {
  source = "../../modules/services/central-backend"

  project_id            = var.project_id
  region                = var.region
  artifact_registry_url = module.artifact_registry.repository_url
  vpc_connector_id      = module.networking.vpc_connector_id
  image_tag             = var.services.central_backend.image_tag
  min_instances         = var.services.central_backend.min_instances
  max_instances         = var.services.central_backend.max_instances
  cpu                   = var.services.central_backend.cpu
  memory                = var.services.central_backend.memory

  # Database
  sql_instance_name   = module.database.instance_name
  database_private_ip = module.database.private_ip
  database_name       = var.services.central_backend.database.name
  database_user       = var.services.central_backend.database.user

  # Redis
  redis_host           = module.redis.host
  redis_port           = module.redis.port
  redis_auth_secret_id = module.redis.auth_secret_id
  redis_tls_enabled    = module.redis.tls_enabled

  # OIDC
  oidc_google_client_id     = var.oidc_google_client_id
  oidc_google_client_secret = var.oidc_google_client_secret
  oidc_google_redirect_uri  = var.oidc_google_redirect_uri

  # Inter-service dependencies
  time_mgmt_url          = module.time_mgmt.service_url
  time_mgmt_service_name = module.time_mgmt.service_name

  depends_on = [module.database, module.redis, module.time_mgmt]
}
