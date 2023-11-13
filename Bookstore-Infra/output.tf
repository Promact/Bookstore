output "EIP" {
  value = aws_eip.nat_eip.address
}

# output "launch_configuration_name" {
#   value = aws_launch_configuration.ecs_launch_config.name
# }
