// file: main.tf
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

resource "aws_launch_configuration" "cluster" {
  associate_public_ip_address = true
  enable_monitoring           = true
  iam_instance_profile        = "${var.instance_profile}"
  image_id                    = "${var.instance_image}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.ssh_key}"
  name_prefix                 = "${var.service_name}-${var.cluster_color}-"
  security_groups             = ["${compact(split(",", "${aws_security_group.cluster.id},${var.cluster_additional_security_groups}"))}"]
  user_data                   = "${var.cluster_user_data}"

  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "cluster" {
  force_delete                = false
  health_check_grace_period   = "${var.cluster_health_check_grace_period}"
  health_check_type           = "ELB"
  launch_configuration        = "${aws_launch_configuration.cluster.id}"
  load_balancers              = ["${var.cluster_load_balancer}"]
  max_size                    = "${var.cluster_max_size}"
  min_size                    = "${var.cluster_min_size}"
  name                        = "${var.service_name}-${var.cluster_color}"
  vpc_zone_identifier         = ["${split(",", var.subnets)}"]
  wait_for_capacity_timeout   = "${var.cluster_wait_for_capacity_timeout}"
  wait_for_elb_capacity       = "${var.cluster_min_size}"

  tag {
    key                 = "Environment"
    value               = "${lower(var.environment_type)}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Color"
    value               = "${lower(var.cluster_color)}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.service_name}"
    propagate_at_launch = true
  }
}