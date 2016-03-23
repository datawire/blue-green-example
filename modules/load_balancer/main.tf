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


resource "aws_security_group" "main" {
  description = "web to load balancer"
  name_prefix = "${var.service_name}-lb-"
  vpc_id      = "${var.vpc_id}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  tags {
    Environment = "${var.environment_type}"
    Service     = "${var.service_name}"
  }
}

resource "aws_elb" "main" {
  connection_draining         = true
  connection_draining_timeout = 300
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  name                        = "${var.service_name}"
  security_groups             = ["${aws_security_group.main.id}"]
  subnets                     = ["${split(",", var.subnets)}"]

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    target              = "HTTP:80/health"
    interval            = 10
  }

  listener {
    instance_port       = 80
    instance_protocol   = "http"
    lb_port             = 80
    lb_protocol         = "http"
  }

  tags {
    Environment = "${var.environment_type}"
    Service     = "${var.service_name}"
  }

  lifecycle { create_before_destroy = true }
}