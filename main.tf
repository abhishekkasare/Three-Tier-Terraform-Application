
provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./vpc"
  region = "ap-south-1"

  # vpc:
  vpc_cidr_block       = "10.0.0.0/16"
  vpc_instance_tenancy = "default"
  vpc_name             = "tf-vpc-hitika"

  #avilaibility_zones:
  availability_zone_1 = "ap-south-1a"
  availability_zone_2 = "ap-south-1b"
 
  # pub_subnets:
  pub_subnet1_cidr    = "10.0.1.0/24"
  pub_subnet1_name    = "tf-pub1-subnet-hitika"
  pub_subnet2_cidr    = "10.0.3.0/24"
  pub_subnet2_name    = "tf-pub2-subnet-hitika"

  # priv_subnets
  priv_subnet1_cidr   = "10.0.2.0/24"
  priv_subnet1_name   = "tf-pri1-subnet-hitika"
  priv_subnet2_cidr   = "10.0.4.0/24"
  priv_subnet2_name   = "Terra-priv2-Subnet"

  # pub_route_table:
  pub_route_table_name = "tf-pubroute-hitika"


  # priv_route_table:
  priv_route_table_name = "tf-priroute-hitika"


  # # public instance:
  # pub_instance_ami      = "ami-03f65b8614a860c29"
  # pub_instance_type     = "t2.micro"
  # pub_instance_key_name = "my-ec2"
  # pub_instance_name     = "Terra-pub-ec2"


  # private instance:
  priv_instance_ami      = "ami-03f65b8614a860c29"
  priv_instance_type     = "t3.medium"
  priv_instance_key_name = "prod"
  priv_instance_name     = "tf-Jenkins-hitika"

}

module "my_cloudfront_s3" {
  source = "./cdn-s3"

  region                            = "ap-south-1"
  cf_origin_access_identity_comment = "MyCustomComment"
  s3_bucket_name                    = "tf-s3-hitika"
  cf_distribution_comment           = "CustomCloudFrontDistribution"
  cf_restriction_locations = ["US", "CA", "GB", "DE", "IN"]
}


module "my_ecr" {
  source = "./ecr"

  region = "ap-south-1"
  ecr    = "hadiya-backend-hitika"
}
