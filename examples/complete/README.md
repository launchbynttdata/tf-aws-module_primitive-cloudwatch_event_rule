# Complete Example

This example demonstrates a complete deployment of the `tf-aws-module_primitive-cloudwatch_event_rule` module with the resource naming module and all configurable options.

## Usage

```hcl
data "aws_region" "current" {}

module "resource_names" {
  source   = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version  = "~> 2.0"

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

  name = var.name != null ? var.name : (var.name_prefix == null ? module.resource_names["event_rule"].standard : null)
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
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.5 |
| aws | ~> 5.14 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| logical_product_family | Logical product family for resource naming. | `string` | n/a | yes |
| logical_product_service | Logical product service for resource naming. | `string` | n/a | yes |
| class_env | Class environment for resource naming (e.g., dev, prod). | `string` | n/a | yes |
| instance_env | Instance environment for resource naming (numeric). | `number` | n/a | yes |
| instance_resource | Instance resource for resource naming. | `string` | n/a | yes |
| resource_names_map | Map of key to resource_name configuration for the resource_name module. The `name` value must be alphanumeric (e.g., eventrule). | `map(object({ name = string, max_length = number }))` | n/a | yes |
| name | The name of the rule. If omitted, uses resource_names generated name. Conflicts with name_prefix. | `string` | `null` | no |
| name_prefix | Creates a unique name beginning with the specified prefix. Conflicts with name. Must be 38 characters or less. | `string` | `null` | no |
| description | The description of the rule. | `string` | `null` | no |
| schedule_expression | The scheduling expression. At least one of schedule_expression or event_pattern is required. | `string` | `null` | no |
| event_pattern | The event pattern described as a JSON object. At least one of schedule_expression or event_pattern is required. | `string` | `null` | no |
| event_bus_name | The name or ARN of the event bus to associate with this rule. | `string` | `null` | no |
| role_arn | The ARN associated with the role used for target invocation. | `string` | `null` | no |
| force_destroy | Used to delete managed rules created by AWS. | `bool` | `false` | no |
| state | State of the rule. Valid values are DISABLED, ENABLED, and ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS. | `string` | `"ENABLED"` | no |
| tags | Map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the EventBridge rule (same as the name). |
| arn | The ARN of the EventBridge rule. |
| name | The name of the EventBridge rule. |
| tags_all | Map of tags assigned to the resource, including those inherited from the provider. |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_event_rule"></a> [event\_rule](#module\_event\_rule) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Logical product family for resource naming. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Logical product service for resource naming. | `string` | n/a | yes |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Class environment for resource naming (e.g., dev, prod). | `string` | n/a | yes |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Instance environment for resource naming (numeric). | `number` | n/a | yes |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Instance resource for resource naming. | `string` | n/a | yes |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | Map of key to resource\_name configuration for the resource\_name module. | <pre>map(object({<br/>    name       = string<br/>    max_length = number<br/>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the rule. If omitted, uses resource\_names generated name. Conflicts with name\_prefix. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with the specified prefix. Conflicts with name. Must be 38 characters or less. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the rule. | `string` | `null` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The scheduling expression. At least one of schedule\_expression or event\_pattern is required. | `string` | `null` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | The event pattern described as a JSON object. At least one of schedule\_expression or event\_pattern is required. | `string` | `null` | no |
| <a name="input_event_bus_name"></a> [event\_bus\_name](#input\_event\_bus\_name) | The name or ARN of the event bus to associate with this rule. | `string` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN associated with the role used for target invocation. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Used to delete managed rules created by AWS. | `bool` | `false` | no |
| <a name="input_state"></a> [state](#input\_state) | State of the rule. Valid values are DISABLED, ENABLED, and ENABLED\_WITH\_ALL\_CLOUDTRAIL\_MANAGEMENT\_EVENTS. | `string` | `"ENABLED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the EventBridge rule (same as the name). |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the EventBridge rule. |
| <a name="output_name"></a> [name](#output\_name) | The name of the EventBridge rule. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider. |
| <a name="output_event_bus_name"></a> [event\_bus\_name](#output\_event\_bus\_name) | The event bus name used for tests. |
| <a name="output_schedule_expression"></a> [schedule\_expression](#output\_schedule\_expression) | The configured schedule expression for test assertions. |
<!-- END_TF_DOCS -->
