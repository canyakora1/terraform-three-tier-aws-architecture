
# Create a custom VPC
resource "aws_vpc" "town_hall_vpc"{
    cidr_block = var.town_hall_vpc
    tags = {
        "Name" = "main-VPC"
    }
}


# Create a public subnet
resource "aws_subnet" "public" {
    count = length(var.DMZPublic1_subnet_cidr)
    vpc_id = aws_vpc.town_hall_vpc.id
    cidr_block = element(var.DMZPublic1_subnet_cidr, count.index)
    availability_zone = element(var.avail_zones, count.index)
    map_public_ip_on_launch = true
    tags = {
      "Name" = "Subnet-${count.index + 1}"
    }
}



# Create a private subnet for the Application Instance 
resource "aws_subnet" "private1" {
    count = length(var.AppLayer_private_cidr)
    vpc_id = aws_vpc.town_hall_vpc.id
    cidr_block = element(var.AppLayer_private_cidr, count.index)
    availability_zone = element(var.avail_zones, count.index)
    map_public_ip_on_launch = false
    tags = {
      "Name" = "Subnet - ${count.index + 1}"
    }
  
}



# Create a private subnet for the Database Instance
resource "aws_subnet" "private2" {
    count = length(var.DB_private_cidr)
    vpc_id = aws_vpc.town_hall_vpc.id
    cidr_block = element(var.DB_private_cidr, count.index)
    availability_zone = element(var.avail_zones, count.index)
    map_public_ip_on_launch = false
    tags = {
      "Name" = "Subnet - ${count.index + 1}"
    }
  
}



# Create an internet gateway
resource "aws_internet_gateway" "town_hall_igw" {
  vpc_id = var.town_hall_vpc.id
}


# Create a public route table and associate it with the public subnets
resource "aws_route_table" "public" {
  vpc_id = var.town_hall_vpc.id
  route = [ {
    carrier_gateway_id = "value"
    cidr_block = "0.0.0.0/0"
    core_network_arn = "value"
    destination_prefix_list_id = "value"
    egress_only_gateway_id = "value"
    gateway_id = aws_internet_gateway.town_hall_igw.id
    instance_id = "value"
    ipv6_cidr_block = "value"
    local_gateway_id = "::/0"
    nat_gateway_id = "value"
    network_interface_id = "value"
    transit_gateway_id = "value"
    vpc_endpoint_id = "value"
    vpc_peering_connection_id = "value"
  } ]
  tags = {
    "Name" = "public"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.DMZPublic1_subnet_cidr.id
}



# Create a private route table and associate it with the private subnets
resource "aws_route_table" "private" {
  vpc_id = var.town_hall_vpc
  
  tags = {
  "Name" = "private-rt"
  }
}
resource "aws_route_table_association" "priate" {
    subnet_id = aws_subnet.private1.id
    route_table_id = aws_route_table.private.id
  
}


# Create an Elastic IP and NAT Gateway
resource "aws_eip" "eip_nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id = aws_subnet.DMZPublic1_subnet_cidr.id
  
  tags = {
  "Name" = "nat-gw"
  }
}


# Add NAT Gateway with private subnet route
resource "aws_route" "private_rt_route" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gateway.id
}

#Create a security group - public access
resource "aws_security_group" "sg_public_access" {
    name = "public_access"
    description = "allow inbound traffic"
    vpc_id = aws_vpc.town_hall_vpc

    ingress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "allow all traffic"
      from_port = 0
      protocol = "-1"
      to_port = 0
    } ]

    egress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "all outbound traffic"
      from_port = 0
      protocol = "-1"
      to_port = 0
    } ]
  
}

# Create a SSH, ICMP, and HTTP connection from public subnet
resource "aws_security_group" "ssh_icmp_http_access" {
  name = "ssh_icmp_http_access"
  description = "Allow ssh, ping and http traffic"
  vpc_id = aws_vpc.town_hall_vpc.id

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow SSH access"
    from_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.sg_public_access.id ]
    to_port = 22
  } 

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow PING access"
    from_port = -1
    protocol = "icmp"
    security_groups = [ aws_security_group.sg_public_access.id ]
    to_port = -1
  } 

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow http access"
    from_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.sg_public_access.id ]
    to_port = 80
  }  

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } ]

}

# Create key pair access
resource "aws_key_pair" "access_keys" {
  key_name = "public_access"
  public_key = file("~/.ssh/aws_access.pub")
}