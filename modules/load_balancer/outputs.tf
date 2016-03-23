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

output "elb_dns_name"                 { value = "${aws_elb.main.dns_name}" }
output "elb_instances"                { value = "${join(",", aws_elb.main.instances)}" }
output "elb_name"                     { value = "${aws_elb.main.name}" }
output "elb_security_group_id"        { value = "${aws_security_group.main.id}" }
output "elb_security_group_name"      { value = "${aws_security_group.main.name}" }
output "elb_security_group_ingress"   { value = "${aws_security_group.main.egress}" }
output "elb_security_group_egress"    { value = "${aws_security_group.main.ingress}" }
output "elb_security_group_vpc"       { value = "${aws_security_group.main.name}" }
output "elb_source_security_group"    { value = "${aws_elb.main.source_security_group_id}" }
output "elb_zone_id"                  { value = "${aws_elb.main.zone_id}" }