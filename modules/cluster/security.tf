// file: security.tf
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

resource "aws_security_group" "cluster" {
  name_prefix = "${var.service_name}-${var.cluster_color}-"
  description = "load balancer to instance and instance to instance"
  vpc_id      = "${var.vpc_id}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  // allow SSH for the demo
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    security_groups = ["${var.cluster_load_balancer_security_group}"]
    to_port = 80
  }

  ingress {
    from_port = 0
    protocol = "-1"
    self = true
    to_port = 0
  }

  tags {
    Environment = "${var.environment_type}"
    Service     = "${var.service_name}"
  }

  lifecycle { create_before_destroy = true }
}