output "runners" {
  value = {
    launch_template_name    = module.runners.launch_template.name
    launch_template_id      = module.runners.launch_template.id
    launch_template_version = module.runners.launch_template.latest_version
    launch_template_ami_id  = module.runners.launch_template.image_id
    lambda_up               = module.runners.lambda_scale_up
    lambda_down             = module.runners.lambda_scale_down
    role_runner             = module.runners.role_runner
    role_scale_up           = module.runners.role_scale_up
    role_scale_down         = module.runners.role_scale_down
    role_pool               = module.runners.role_pool
    labels                  = sort(split(",", local.runner_labels))
    logfiles                = module.runners.logfiles
  }
}

output "binaries_syncer" {
  value = var.enable_runner_binaries_syncer ? {
    lambda      = module.runner_binaries[0].lambda
    lambda_role = module.runner_binaries[0].lambda_role
    location    = "s3://${module.runner_binaries[0].bucket.id}/module.runner_binaries[0].bucket.key"
    bucket      = module.runner_binaries[0].bucket
  } : null
}

output "webhook" {
  value = {
    gateway     = module.webhook.gateway
    lambda      = module.webhook.lambda
    lambda_role = module.webhook.role
    endpoint    = "${module.webhook.gateway.api_endpoint}/${module.webhook.endpoint_relative_path}"
  }
}

output "ssm_parameters" {
  value = module.ssm.parameters
}


output "queues" {
  description = "SQS queues."
  value = {
    build_queue_arn            = aws_sqs_queue.queued_builds.arn
    build_queue_dlq_arn        = var.redrive_build_queue.enabled ? aws_sqs_queue.queued_builds_dlq[0].arn : null
    webhook_workflow_job_queue = try(aws_sqs_queue.webhook_events_workflow_job_queue[0], null) != null ? aws_sqs_queue.webhook_events_workflow_job_queue[0].arn : ""
  }
}
