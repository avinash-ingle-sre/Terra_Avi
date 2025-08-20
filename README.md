


Terraform AWS Simple Demo (VPC + EC2 + S3)
VPC (public subnet + IGW + route)

EC2 (t2.micro) + Nginx via user_data

S3 (versioning + SSE + public access block)

Outputs: EC2 public IP, S3 bucket name

Quickstart:

cd envs/dev

terraform init

ACC=$(aws sts get-caller-identity --query Account --output text)

AMI=$(aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" "Name=state,Values=available" --query "reverse(sort_by(Images,&CreationDate))[:1].ImageId" --output text --region ap-south-1)

terraform plan -var "ami_id=$AMI" -var "account_id=$ACC" -out tfplan

terraform apply -auto-approve tfplan

terraform output ec2_public_ip

Cleanup:

terraform destroy -auto-approve
EOF

git add README.md

git commit -m "docs: add quickstart README"

git push
