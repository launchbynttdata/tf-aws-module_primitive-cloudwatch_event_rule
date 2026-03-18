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

data "aws_region" "current" {}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  cloud_resource_type     = each.value.name
  maximum_length          = each.value.max_length

  region                = join("", split("-", data.aws_region.current.name))
  use_azure_region_abbr = false
}

module "event_rule" {
  source = "../.."

  name                = var.name != null ? var.name : (var.name_prefix == null ? module.resource_names["event_rule"].standard : null)
  name_prefix         = var.name_prefix
  description         = var.description
  schedule_expression = var.schedule_expression
  event_pattern       = var.event_pattern
  event_bus_name      = var.event_bus_name
  role_arn            = var.role_arn
  force_destroy       = var.force_destroy
  state               = var.state
  tags                = var.tags
}
