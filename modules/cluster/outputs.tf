// file: outputs.tf
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

output "cluster_color"                      { value = "${var.cluster_color}" }
output "cluster_health_check_type"          { value = "${aws_autoscaling_group.cluster.health_check_type}" }
output "cluster_health_check_grace_period"  { value = "${aws_autoscaling_group.cluster.health_check_grace_period}" }
output "cluster_launch_configuration"       { value = "${aws_autoscaling_group.cluster.launch_configuration}" }
output "cluster_load_balancers"             { value = "${join(",", aws_autoscaling_group.cluster.load_balancers)}" }
output "cluster_min_size"                   { value = "${aws_autoscaling_group.cluster.min_size}" }
output "cluster_max_size"                   { value = "${aws_autoscaling_group.cluster.max_size}" }
output "cluster_name"                       { value = "${aws_autoscaling_group.cluster.name}" }
output "cluster_security_group_id"          { value = "${aws_security_group.cluster.id}" }
output "cluster_security_group_name"        { value = "${aws_security_group.cluster.name}" }
output "cluster_security_group_ingress"     { value = "${aws_security_group.cluster.egress}" }
output "cluster_security_group_egress"      { value = "${aws_security_group.cluster.ingress}" }
output "cluster_security_group_vpc"         { value = "${aws_security_group.cluster.name}" }
output "cluster_vpc"                        { value = "${aws_autoscaling_group.cluster.vpc_zone_identifier}" }
output "cluster_zones"                      { value = "${join(",", aws_autoscaling_group.cluster.availability_zones)}" }