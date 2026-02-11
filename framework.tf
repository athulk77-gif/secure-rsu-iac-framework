module "secure_rsu_core" {
  source = "./modules/secure_rsu_core"

  name_prefix = local.name_prefix
  tags        = local.common_tags
  kms_key_arn = aws_kms_key.rsu_key.arn
}
