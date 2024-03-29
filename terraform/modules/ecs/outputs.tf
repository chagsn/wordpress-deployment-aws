output "ecs_task_set_stability_status" {
    description = "Stability status of the task set: STEADY_STATE or STABILIZING"
    # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_TaskSet.html
    value = module.wordpress-service.task_set_stability_status
}

output "ecs_task_set_status" {
    description = "Status of the task set: PRIMARY, ACTIVE or DRAINING"
    # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_TaskSet.html
    value = module.wordpress-service.task_set_status
}