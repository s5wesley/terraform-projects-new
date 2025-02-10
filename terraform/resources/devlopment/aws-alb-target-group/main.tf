module "alb" {
  source   = "../../../modules/aws-alb-target-group" # Change to your module path
  region   = "us-east-1"
  alb_name = "my-app-alb"
  vpc_id   = "vpc-057661e092e536f51"
  subnets  = ["subnet-0efba499e740dd3a1", "subnet-0008f1cd6d2c96b43", "subnet-0964a842253b9e94e"]
}

output "alb_dns" {
  value = module.alb.alb_dns_name
}
