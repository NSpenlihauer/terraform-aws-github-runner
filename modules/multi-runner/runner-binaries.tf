module "runner_binaries" {
  source   = "../runner-binaries-syncer"
  for_each = local.unique_os_and_arch
  prefix   = "${var.prefix}-${each.value.os_type}-${each.value.architecture}"
  tags     = local.tags

  distribution_bucket_name = "${var.prefix}-${each.value.os_type}-${each.value.architecture}-dist-${random_string.random.result}"

  runner_os           = each.value.os_type
  runner_architecture = each.value.architecture

  lambda_s3_bucket                = var.lambda_s3_bucket
  syncer_lambda_s3_key            = var.syncer_lambda_s3_key
  syncer_lambda_s3_object_version = var.syncer_lambda_s3_object_version
  lambda_runtime                  = var.lambda_runtime
  lambda_architecture             = var.lambda_architecture
  lambda_zip                      = var.runner_binaries_syncer_lambda_zip
  lambda_timeout                  = var.runner_binaries_syncer_lambda_timeout
  logging_retention_in_days       = var.logging_retention_in_days
  logging_kms_key_id              = var.logging_kms_key_id

  server_side_encryption_configuration = var.runner_binaries_s3_sse_configuration

  role_path                 = var.role_path
  role_permissions_boundary = var.role_permissions_boundary

  log_type  = var.log_type
  log_level = var.log_level

  lambda_subnet_ids         = var.lambda_subnet_ids
  lambda_security_group_ids = var.lambda_security_group_ids
  aws_partition             = var.aws_partition

  lambda_principals = var.lambda_principals
}
locals {
  runner_binaries_by_os_and_arch_map = {
    for k, v in module.runner_binaries : k => { arn = v.bucket.arn, id = v.bucket.id, key = v.runner_distribution_object_key }
  }
}
