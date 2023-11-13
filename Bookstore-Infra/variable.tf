variable "project" {
  type        = string
  description = "Project Title"
  default     = "bookstore"
}


variable "region" {
  type        = string
  description = "Default Region for Project"
  default     = "us-east-1"
}
variable "vpc_cidr" {
  type        = string
  description = "Project Title"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "AMI" {
  type        = string
  description = "Project Title"
  default     = "ami-0eab4597a7e92d75d" #"ami-0077a350292f081f3"#"ami-054c337ee5048c313"#"ami-0dfda8a3ee7678578" #"ami-0dce57de6dcc3a6cc"
}


# variable "lg_user_data" {
#   type        = string
#   description = "Project Title"
#   default     = <<-EOT
#     #!/bin/bash
#     echo ECS_CLUSTER=my-cluster >> /etc/ecs/ecs.config
#   EOT
# }
# variable "lg_user_data" {
#   type        = string
#   description = "Project Title"
#   default     = "#!/bin/bash \n echo ECS_CLUSTER=my-cluster >> /etc/ecs/ecs.config"
# }

variable "asg_instance_type" {
  type        = string
  description = "Instance Type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Key Name"
  # default     = "./bookstore.pub"
  default = "Rumit_Key"
}

##########################################################################

variable "desired_capacity" {
  type        = number
  description = "Desired number of Instances ASG can Create."
  default     = 1
}

variable "min_size" {
  type        = number
  description = "Minimum Number of Instances ASG can Create."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum Number of Instances ASG can Create."
  default     = 5
}

variable "health_check_grace_period" {
  type        = number
  description = "Instance Type"
  default     = 300
}

variable "db_instance_class" {
  type        = string
  description = "Instance Type"
  default     = "db.t3.micro"
}

variable "repository_names" {
  type    = list(string)
  default = [ "host", "web", "auth", "migrator"]
}

# variable "launch_configuration_name" {
#     description = "output of the AWS launch_configuration"

# }