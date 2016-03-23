// file: variables.tf

variable "availability_zones" {
  description = "a comma separated list of availability zone letters."
  default = {
    "us-east-1" = "a,c,d,e"
    "us-west-2" = "a,b,c"
  }
}

variable "blue_cluster_max_size"  { description = "the maximum number of allowed instances in the blue cluster." }
variable "blue_cluster_min_size"  { description = "the minimum number of allowed instances in the blue cluster." }
variable "blue_instance_image"    { description = "the AMI ID associated with the blue cluster launch configuration." }
variable "blue_instance_type"     { description = "the EC2 instance type associated with the blue cluster launch configuration." }

variable "environment_region"     { description = "the AWS ID of the region (e.g.: 'us-east-1')." }
variable "environment_type"       { description = "the name of the environment (e.g.: 'dev' or 'prod')." }

variable "green_cluster_max_size" { description = "the maximum number of allowed instances in the green cluster." }
variable "green_cluster_min_size" { description = "the minimum number of allowed instances in the green cluster." }
variable "green_instance_image"   { description = "the AMI ID associated with the green cluster launch configuration." }
variable "green_instance_type"    { description = "the EC2 instance type associated with the green cluster launch configuration." }

variable "public_subnet_cidr_suffixes" {
  description = "the CIDR suffixes for public subnets."
  default = {
    "0" = "0.0/22"
    "1" = "4.0/22"
    "2" = "8.0/22"
    "3" = "12.0/22"
  }
}

variable "service_name" {
  description = "the name of the service, for example, 'discovery', 'identity', 'juggernaut'."
}

variable "ssh_key_name" {
  description = "the name of the SSH key to associate with the pingbox"
  default = {
    "us-east-1" = "boston-devops-demo"
    "us-west-2" = "boston-devops-demo"
  }
}

variable "vpc_cidr_block_prefix" {
  description = "the prefix of the VPC CIDR block (e.g. 10.0, assume: /16)."
  default     = "10.0"
}

variable "vpc_name" {
  description = "the name of the VPC."
}
