# terraform-three-tier-aws-architecture
Building a 3 tier AWS architecture using terraform

To build a three-tier AWS architecture using Terraform, you would typically follow these steps:
Create a VPC: Use the aws_vpc resource to create a Virtual Private Cloud (VPC) that will house your architecture. You can specify the CIDR block range for your VPC, and any additional options such as DNS support or tenancy.

Create subnets: Use the aws_subnet resource to create subnets within your VPC. Typically, you would create at least one public subnet for your web tier, and one or more private subnets for your application and database tiers. Be sure to specify the VPC ID and CIDR block range for each subnet.

Create an internet gateway: Use the aws_internet_gateway resource to create an internet gateway for your VPC. This will allow resources in your public subnets to communicate with the internet.

Create a route table: Use the aws_route_table resource to create a route table for your VPC. Associate your public subnet with this route table, and add a default route to the internet gateway.

Create security groups: Use the aws_security_group resource to create security groups for your instances. You'll need separate security groups for your web, application, and database tiers, and you'll need to specify the appropriate inbound and outbound rules for each group.

Launch EC2 instances: Use the aws_instance resource to launch EC2 instances in your subnets. Be sure to specify the appropriate instance type, AMI, subnet ID, security group IDs, and any additional options such as user data or tags.

Create an elastic load balancer: Use the aws_lb resource to create an elastic load balancer (ELB) in your public subnet. Associate your web tier instances with the ELB target group, and configure any necessary listener and health check settings.

Create a database: Use the aws_db_instance resource to create a database instance in your private subnet. Be sure to specify the appropriate database engine, instance type, subnet group, security group, and any additional options such as parameter group settings or backup retention.

Connect the tiers: Configure your application tier instances to connect to the database instance, using the appropriate connection string and credentials. You may also need to configure your security groups and network ACLs to allow the necessary traffic.
    
These are the basic steps involved in building a three-tier AWS architecture using Terraform. Depending on your specific requirements, you may need to add additional resources or configuration options. Be sure to refer to the Terraform documentation and AWS documentation for detailed guidance and best practices.

