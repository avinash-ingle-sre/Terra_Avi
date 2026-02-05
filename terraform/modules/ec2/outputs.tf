# १. बँक अ‍ॅप सर्व्हरचा पब्लिक आयपी (बाहेरून कनेक्ट करण्यासाठी)
output "app_server_public_ip" {
  description = "Public IP of the Bank App Server"
  value       = aws_instance.app_server.public_ip
}

# २. इंटरनल सर्व्हरचा प्रायव्हेट आयपी (फाईल ट्रान्सफरसाठी लागेल)
output "internal_server_private_ip" {
  description = "Private IP of the Internal Bank Server"
  value       = aws_instance.internal_server.private_ip
}

# ३. अ‍ॅप सर्व्हरचा आयडी
output "app_instance_id" {
  value = aws_instance.app_server.id
}
