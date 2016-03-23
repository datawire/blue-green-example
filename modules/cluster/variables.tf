// file: variables.tf
//
// Copyright 2016 Datawire. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

variable "alarm_actions" {
  description = "a comma-seperated value list of ARN's for alarm actions."
  default     = ""
}

variable "alarm_actions_enabled" {
  description = "configures whether alarm actions are enabled if any are provided."
  default     = "false"
}

variable "cluster_color" {
  description = "the color of the cluster."
}

variable "cluster_load_balancer" {
  description = "the ID of the elastic load balancer."
}

variable "cluster_load_balancer_security_group" {
  description = "the ID of the load balancer security group."
}

variable "cluster_health_check_grace_period" {
  description = "the duration of time after an instance boots before checking health."
  default = "300"
}

variable "cluster_min_size" {
  description = "the minimum size of the auto scaling group."
}

variable "cluster_max_size" {
  description = "the maximum size of the auto scaling group."
}

variable "cluster_additional_security_groups" {
  description = "a list of additional security groups that cluster instances will belong to."
  default = ""
}

variable "cluster_user_data" {
  description = "the user data script to provide to the auto scaling group launch configuration."
  default = ""
}

variable "cluster_wait_for_capacity_timeout" {
  description = "the amount of time Terraform should wait for an ELB to reach capacity of registered instances."
  default = "10m"
}

variable "environment_type" {
  description = "the name of the environment (e.g.: 'dev' or 'prod')."
}

variable "instance_image" {
  description = "the AMI ID of the desired EC2 AMI to use."
}

variable "instance_profile" {
  description = "the IAM instance profile to assign to EC2 instances"
}

variable "instance_type" {
  description = "the type of desired EC2 instance to use."
}

variable "service_name" {
  description = "the name of the service."
}

variable "ssh_key" {
  description = "the name of the SSH key to associate with the each instance"
}

variable "subnets" {
  description = "the subnets that the Jenkin's master can be launched into."
}

variable "vpc_id" {
  description = "the ID of the VPC."
}