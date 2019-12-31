# Packer AWS Machine Images
[Packer](http://www.packer.io/) templates to create Amazon [AMIs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html).

# Prerequisites
Tested on an Apple Mac running macOS v10.14.2, but should work on any Linux OS.

  * Install Packer v1.3.4+
  * On target AWS account, create a `packer` IAM user, and attach below `PackerBuilder` policy.
  ```
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PackerBuilder",
        "Effect": "Allow",
        "Action": [
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CopyImage",
          "ec2:CopyImage",
          "ec2:CreateImage",
          "ec2:CreateKeypair",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteKeypair",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSnapshot",
          "ec2:DeleteVolume",
          "ec2:DeregisterImage",
          "ec2:DescribeImageAttribute",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
          "ec2:GetPasswordData",
          "ec2:ModifyImageAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:RegisterImage",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ],
        "Resource": "*"
      }
    ]
  }
  ```
  * Logon to target AWS account via CLI using above `packer` user.
  * Ensure [aws_source_ami](https://github.com/lencap/packer-aws/blob/master/centos7.6.1810-amazon-ami.json#L8) is the CentOS 7.6.1810 image base you need.
  * Ensure [aws_security_group_ids](https://github.com/lencap/packer-aws/blob/master/centos7.6.1810-amazon-ami.json#L7) are valid EC2 Security Group IDs in your target AWS account 
  * STILL UNDER CONSTRUCTION ... there are more parameters

# Build Images
| Command | Description |
| :----------- | :----------- |
| `packer validate centos7.6.1810-ami.json` | First, confirm template is good |
| `packer build centos7.6.1810-ami.json` | Build CentOS 7.6.1810 AMI |

Use newly created AMI as you see fit.

# Test Vagrant Box
To test the new AMI, create a new EC2 instance using the newly outputted AMI ID.
