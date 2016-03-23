// file: alarms.tf
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

resource "aws_cloudwatch_metric_alarm" "no_healthy_instances" {
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${compact(split(",", var.alarm_actions))}"]
  alarm_description   = "${var.service_name} ELB no healthy instances."
  alarm_name          = "${var.service_name}-no-healthy"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions {
    LoadBalancerName = "${aws_elb.main.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_5xx_errors" {
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${compact(split(",", var.alarm_actions))}"]
  alarm_description   = "${var.service_name} ELB HTTP 5xx errors."
  alarm_name          = "-${var.service_name}-elb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX"
  namespace           = "AWS/ELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions {
    LoadBalancerName = "${aws_elb.main.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_average_latency" {
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${compact(split(",", var.alarm_actions))}"]
  alarm_description   = "${var.service_name} ELB high latency."
  alarm_name          = "${var.service_name}-high-average-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Latency"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Average"
  threshold           = 2

  dimensions {
    LoadBalancerName = "${aws_elb.main.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "instance_5xx_errors" {
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${compact(split(",", var.alarm_actions))}"]
  alarm_description   = "${var.service_name} instance HTTP 5xx errors."
  alarm_name          = "-${var.service_name}-instance-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Backend_5XX"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  dimensions {
    LoadBalancerName = "${aws_elb.main.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "backend_errors" {
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${compact(split(",", var.alarm_actions))}"]
  alarm_description   = "${var.service_name} ELB backend connection errors."
  alarm_name          = "${var.service_name}-backend-connection-errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BackendConnectionErrors"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  dimensions {
    LoadBalancerName = "${aws_elb.main.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "surge_queue_full" {
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${compact(split(",", var.alarm_actions))}"]
  alarm_description   = "${var.service_name} ELB surge queue full."
  alarm_name          = "${var.service_name}-surge-queue-full"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "SurgeQueueLength"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1024

  dimensions {
    LoadBalancerName = "${aws_elb.main.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "surge_queue_spillover" {
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${compact(split(",", var.alarm_actions))}"]
  alarm_description   = "${var.service_name} ELB surge queue spillover."
  alarm_name          = "${var.service_name}-surge-queue-spillover"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "SpilloverCount"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  dimensions {
    LoadBalancerName = "${aws_elb.main.name}"
  }
}