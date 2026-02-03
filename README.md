


# 🚀 Terra_Avi - Enterprise AWS Infrastructure with Terraform

हे एक प्रोफेशनल-ग्रेड **Infrastructure as Code (IaC)** प्रोजेक्ट आहे, ज्यामध्ये AWS इन्फ्रास्ट्रक्चर मॅनेज करण्यासाठी टेराफॉर्मचा वापर केला आहे. हा प्रोजेक्ट केवळ इन्फ्रास्ट्रक्चर उभारत नाही, तर त्यात **Security**, **Scalability**, आणि **State Management** यांसारख्या SRE बेस्ट प्रॅक्टिसेसचा अंतर्भाव आहे.

---

## 🏗️ Architecture: Remote State & Locking
आपण टेराफॉर्मची 'State File' स्थानिक मशीनवर न ठेवता सुरक्षितरीत्या क्लाउडवर हलवली आहे.



* **AWS S3:** 'Single Source of Truth' म्हणून स्टेट फाईल्स साठवण्यासाठी.
* **AWS DynamoDB:** जेव्हा एकापेक्षा जास्त इंजिनिअर्स एकाच वेळी काम करतात, तेव्हा 'State Corruption' टाळण्यासाठी 'State Locking' करतो.

---

## 📂 Project Structure
रेपोचे स्ट्रक्चर 'Maintainability' आणि 'Modularity' लक्षात घेऊन बनवले आहे:

```text
Terra_Avi/
├── .git/hooks/              # Pre-commit quality gates
├── terraform/
│   ├── global/
│   │   └── s3-backend/      # Remote State (S3 + DynamoDB) setup
│   ├── modules/
│   │   ├── vpc/             # Reusable Networking Module
│   │   ├── ec2/             # Compute Module
│   │   └── s3/              # Storage Module
│   └── envs/
│       ├── dev/             # Development Environment
│       └── prod/            # Production Environment
└── README.md


---------------------------------------------------------------


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


