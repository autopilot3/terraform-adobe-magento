# ------------------------
# | ElastiCache (Redis)  |
# ------------------------

locals { 
  # if the number in the cluster is less than the AZ count, return from random_shuffle. Otherwise the entire list.
  azs_cache = var.redis_clusters_cache < length(var.azs) ? random_shuffle.redis_cache_azs.result : var.azs
  azs_session = var.redis_clusters_session < length(var.azs) ? random_shuffle.redis_session_azs.result : var.azs

}

resource "random_shuffle" "redis_cache_azs" { 
  input        = var.azs
  result_count = var.redis_clusters_cache
}
resource "random_shuffle" "redis_session_azs" { 
  input        = var.azs
  result_count = var.redis_clusters_session
}


resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${var.project}-elasticache-subnet-group"
  description = "Use the private subnet for ElastiCache instances."
  subnet_ids  = var.private_subnet_ids
}

resource "aws_elasticache_parameter_group" "magento_required" {
  name   = "${var.project}-magento-required"
  family = "redis6.x"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lfu"
  }
}

# Redis instance for backend caching
resource "aws_elasticache_replication_group" "redis-backend-cache" {
  automatic_failover_enabled = var.redis_clusters_cache == 1 ? false : true
  availability_zones         = local.azs_cache
  multi_az_enabled           = var.redis_clusters_cache == 1 ? false : true
  engine                     = "redis"
  engine_version             = var.redis_engine_version
  replication_group_id       = "${var.project}-redis-backend-cache"
  description                = "${var.project}-Redis Replication Group"
  node_type                  = var.redis_instance_type_cache
  num_cache_clusters         = var.redis_clusters_cache
  parameter_group_name       = aws_elasticache_parameter_group.magento_required.name
  subnet_group_name          = aws_elasticache_subnet_group.elasticache.name
  security_group_ids         = [var.sg_redis_id]
  port                       = 6379
  at_rest_encryption_enabled = true

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }

  tags = {
    Name      = "${var.project}-magento-redis-backend-cache"
    Terraform = true
  }
}

# Redis instance for sessions
resource "aws_elasticache_replication_group" "redis-sessions" {
  automatic_failover_enabled = var.redis_clusters_cache == 1 ? false : true
  availability_zones         = local.azs_session
  multi_az_enabled           = var.redis_clusters_session == 1 ? false : true
  engine                     = "redis"
  engine_version             = var.redis_engine_version
  replication_group_id       = "${var.project}-redis-sessions"
  description                = "${var.project}-Redis Replication Group"
  node_type                  = var.redis_instance_type_session
  num_cache_clusters         = var.redis_clusters_session
  parameter_group_name       = aws_elasticache_parameter_group.magento_required.name
  subnet_group_name          = aws_elasticache_subnet_group.elasticache.name
  security_group_ids         = [var.sg_redis_id]
  port                       = 6379
  at_rest_encryption_enabled = true

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }

  tags = {
    Name      = "${var.project}-magento-redis-sessions"
    Terraform = true
  }
}
