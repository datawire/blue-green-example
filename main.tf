// file: service.py
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

provider "aws" {
  region = "${var.environment_region}"
}

resource "template_file" "blue_cloud_init" {
  template = "${file("${path.module}/scripts/blue/cloud-init.tpl")}"
  vars = {
    message = "I am blue!"
  }

  lifecycle { create_before_destroy = true }
}

resource "template_file" "green_cloud_init" {
  template = "${file("${path.module}/scripts/green/cloud-init.tpl")}"
  vars = {
    message = "I am green!"
  }

  lifecycle { create_before_destroy = true }
}


module "load_balancer" {
  source = "modules/load_balancer"

  alarm_actions_enabled = false
  service_name          = "${var.service_name}"
  environment_type      = "dev"
  subnets               = "${join(",", aws_subnet.public.*.id)}"
  vpc_id                = "${aws_vpc.main.id}"
}

module "blue" {
  source = "modules/cluster"

  cluster_color                        = "blue"
  cluster_max_size                     = "${var.blue_cluster_max_size}"
  cluster_min_size                     = "${var.blue_cluster_max_size}"
  cluster_load_balancer                = "${module.load_balancer.elb_name}"
  cluster_load_balancer_security_group = "${module.load_balancer.elb_source_security_group}"
  cluster_user_data                    = "${template_file.blue_cloud_init.rendered}"
  environment_type                     = "dev"
  instance_image                       = "${var.blue_instance_image}"
  instance_profile                     = "${aws_iam_instance_profile.blue.id}"
  instance_type                        = "${var.blue_instance_type}"
  service_name                         = "${var.service_name}"
  ssh_key                              = "${lookup(var.ssh_key_name, var.environment_region)}"
  subnets                              = "${join(",", aws_subnet.public.*.id)}"
  vpc_id                               = "${aws_vpc.main.id}"
}

module "green" {
  source = "modules/cluster"

  cluster_color                        = "green"
  cluster_max_size                     = "${var.green_cluster_max_size}"
  cluster_min_size                     = "${var.green_cluster_max_size}"
  cluster_load_balancer                = "${module.load_balancer.elb_name}"
  cluster_load_balancer_security_group = "${module.load_balancer.elb_source_security_group}"
  cluster_user_data                    = "${template_file.green_cloud_init.rendered}"
  environment_type                     = "dev"
  instance_image                       = "${var.green_instance_image}"
  instance_profile                     = "${aws_iam_instance_profile.green.id}"
  instance_type                        = "${var.green_instance_type}"
  service_name                         = "${var.service_name}"
  ssh_key                              = "${lookup(var.ssh_key_name, var.environment_region)}"
  subnets                              = "${join(",", aws_subnet.public.*.id)}"
  vpc_id                               = "${aws_vpc.main.id}"
}