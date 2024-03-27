
#run "create_webservice" {
#    assert {
#        condition = length(aws_route53_record.some_record) > 4
#        error_message    = "Route53 record does not exist"
#    }
#
  /*assert {
    condition = length(module.rds.module.some_rds.resources) > 0 
    error_message    = "RDS instance is not created or not in Multi-AZ mode"
  }
  
  assert {
    condition = length(module.route53.aws_route53_record.some_record) > 4
    error_message    = "Route53 record does not exist"
  }
  
  assert {
    condition = length(module.efs.aws_efs_file_system.some_efs) > 0
    error_message    = "EFS file system is not created"
  }
  
  assert {
    condition = length(module.ecs.aws_ecs_cluster.some_cluster) > 0 && module.ecs.aws_ecs_cluster.some_cluster.status == "ACTIVE"
    error_message    = "ECS cluster is not running"
  }*/

}