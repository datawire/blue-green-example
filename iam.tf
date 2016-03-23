// file: iam.tf
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

resource "template_file" "blue_role" {
  template = "${file("${path.module}/iam/blue/role.json")}"

  lifecycle { create_before_destroy = true }
}

resource "template_file" "blue_policy" {
  template = "${file("${path.module}/iam/blue/policy.json")}"

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role" "blue" {
  name               = "${var.service_name}-blue"
  assume_role_policy = "${template_file.blue_role.rendered}"

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy" "blue" {
  name    = "${aws_iam_role.blue.name}-policy"
  role    = "${aws_iam_role.blue.id}"
  policy  = "${template_file.blue_policy.rendered}"

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_instance_profile" "blue" {
  name  = "${aws_iam_role.blue.name}-profile"
  roles = ["${aws_iam_role.blue.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "green_role" {
  template = "${file("${path.module}/iam/green/role.json")}"

  lifecycle { create_before_destroy = true }
}

resource "template_file" "green_policy" {
  template = "${file("${path.module}/iam/green/policy.json")}"

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role" "green" {
  name               = "${var.service_name}-green"
  assume_role_policy = "${template_file.green_role.rendered}"

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy" "green" {
  name    = "${aws_iam_role.green.name}-policy"
  role    = "${aws_iam_role.green.id}"
  policy  = "${template_file.green_policy.rendered}"

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_instance_profile" "green" {
  name  = "${aws_iam_role.green.name}-profile"
  roles = ["${aws_iam_role.green.name}"]

  lifecycle {
    create_before_destroy = true
  }
}