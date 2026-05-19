# tf-aws-module_primitive-cloudwatch_event_rule

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

This Terraform module provides a primitive wrapper for the [aws_cloudwatch_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) resource (EventBridge Rule, formerly CloudWatch Events). It supports all documented functionality including schedule expressions, event patterns, custom event buses, and rule state configuration.

## Usage

```hcl
module "event_rule" {
  source = "terraform.registry.launch.nttdata.com/module_primitive/cloudwatch_event_rule/aws"

  name                = "my-scheduled-rule"
  schedule_expression = "rate(1 hour)"
  description         = "Runs every hour"
  state               = "ENABLED"
  tags                = var.tags
}
```

## Pre-Commit Hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines hooks for Terraform, Go, and common linting. The `commitlint` hook enforces conventional commit format. The `detect-secrets-hook` prevents new secrets from being introduced. See the [detect-secrets documentation](https://github.com/Yelp/detect-secrets) for details.

Install the commit-msg hook manually:

```
pre-commit install --hook-type commit-msg
```

## Local Testing

1. Run `make configure` to install dependencies.
2. For AWS, set credentials via `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, or `AWS_PROFILE`.
3. Create `examples/complete/provider.tf` if needed (often provided by Makefile).
4. Run `make check` to run lint, validate, plan, and tests.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.14 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the rule. | `string` | `null` | no |
| <a name="input_event_bus_name"></a> [event\_bus\_name](#input\_event\_bus\_name) | The name or ARN of the event bus to associate with this rule. If omitted, the default event bus is used. | `string` | `null` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | The event pattern described as a JSON object. At least one of schedule\_expression or event\_pattern is required. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Used to delete managed rules created by AWS. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the rule. If omitted, Terraform will assign a random, unique name. Conflicts with name\_prefix. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with the specified prefix. Conflicts with name. Must be 38 characters or less. | `string` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The Amazon Resource Name (ARN) associated with the role that is used for target invocation. | `string` | `null` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). At least one of schedule\_expression or event\_pattern is required. Can only be used on the default event bus. | `string` | `null` | no |
| <a name="input_state"></a> [state](#input\_state) | State of the rule. Valid values are DISABLED, ENABLED, and ENABLED\_WITH\_ALL\_CLOUDTRAIL\_MANAGEMENT\_EVENTS. ENABLED\_WITH\_ALL\_CLOUDTRAIL\_MANAGEMENT\_EVENTS cannot be used with schedule\_expression. | `string` | `"ENABLED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the rule. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the resource (same as the name). |
| <a name="output_name"></a> [name](#output\_name) | The name of the rule. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider. |
<!-- END_TF_DOCS -->
