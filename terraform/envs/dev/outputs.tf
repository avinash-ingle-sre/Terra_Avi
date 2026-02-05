# १. VPC ID आउटपुट
output "vpc_id" {
  value = module.vpc.vpc_id
}

# २. बँक अ‍ॅप सर्व्हरचा पब्लिक आयपी (आता आपण नवीन नाव वापरतोय)
output "bank_app_public_ip" {
  value = module.ec2.app_server_public_ip
}

# ३. बँक इंटरनल सर्व्हरचा प्रायव्हेट आयपी
output "bank_internal_private_ip" {
  value = module.ec2.internal_server_private_ip
}
