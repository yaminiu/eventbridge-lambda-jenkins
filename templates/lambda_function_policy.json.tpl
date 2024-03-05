{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:ap-southeast-2:${aws_account}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": [
                "${snsxmateremail}",
                "${snsxmatermessage}"
            ] 
        },
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
			"Action": [
				"s3:ListBucket",
				"s3:HeadBucket",
				"s3:GetBucketLocation"
			],
            "Resource": ["arn:aws:s3:::${s3_installation_bucket}" ]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": [
                "s3:*Object",
                "s3:*ObjectAcl"
            ],
            "Resource": ["arn:aws:s3:::${s3_installation_bucket}/*"]
        },
        {
            "Sid": "AllBucketActions",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Put*"
            ],
            "Resource": ["arn:aws:s3:::${s3_installation_bucket}/*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ssm:GetParameter",
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:AttachNetworkInterface",
                "ec2:AssignPrivateIpAddresses",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        }
    ]
}