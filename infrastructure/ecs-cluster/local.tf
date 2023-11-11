locals {
    vpc_cidr = "10.0.0.0/16"
    region = "eu-north-1"
    resource_tag_prefix = "bookstore"
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
    availability_zones = ["eu-north-1a", "eu-north-1b"]
    ami_id = "ami-0cc713d0428957edd"
    instance_type = "t3.small"
    cluster_name = "bookstore-cluster"
    service_instance_count = 3
    elastic_ip_count = 2
    nat_gateway_count = 2
    asg_min_size = 1
    asg_max_size = 2
    asg_desired_size = 1
}