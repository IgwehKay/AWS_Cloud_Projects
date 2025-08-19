  resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
    enable_dns_support = true
    enable_dns_hostnames = true
  }

  resource "aws_subnet" "sub1" {
    vpc_id                  = aws_vpc.myvpc.id
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
  }

  resource "aws_subnet" "sub2" {
    vpc_id                  = aws_vpc.myvpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
  }

  resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
  }

  resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  }

  resource "aws_route_table_association" "rta1" {
    subnet_id      = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
  }

  resource "aws_route_table_association" "rta2" {
    subnet_id      = aws_subnet.sub2.id
    route_table_id = aws_route_table.RT.id
  }

  resource "aws_security_group" "WebSG" {
    name        = "WebSG"
    description = "Allow HTTP and SSH inbound traffic and all outbound traffic"
    vpc_id      = aws_vpc.myvpc.id

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  resource "aws_s3_bucket" "mybucket" {
    bucket = "my-tf2025-test-bucket"
  }


  resource "aws_instance" "web-server1" {
    ami                    = "ami-020cba7c55df1f615"
    instance_type          = "t3.micro"
    vpc_security_group_ids = [aws_security_group.WebSG.id]
    subnet_id              = aws_subnet.sub1.id
    user_data              = file("userdata.sh")
  }

  resource "aws_instance" "web-server2" {
    ami                    = "ami-020cba7c55df1f615"
    instance_type          = "t3.micro"
    vpc_security_group_ids = [aws_security_group.WebSG.id]
    subnet_id              = aws_subnet.sub2.id
    user_data              = file("userdata1.sh")
  }

  resource "aws_lb" "myalb" {
    name               = "myalb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.WebSG.id]
    subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]


    tags = {
      Name = "web"
    }
  }

  resource "aws_lb_target_group" "TG" {
    name     = "myTG"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.myvpc.id
    health_check {
      path = "/"
      port = "traffic-port"
    }
  }

  resource "aws_lb_target_group_attachment" "attach1" {
    target_group_arn = aws_lb_target_group.TG.arn
    target_id        = aws_instance.web-server1.id
    port             = 80

  }

  resource "aws_lb_target_group_attachment" "attach2" {
    target_group_arn = aws_lb_target_group.TG.arn
    target_id        = aws_instance.web-server2.id
    port             = 80

  }

  #attaching the load balancer to its target group by defining a listener rule
  resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.myalb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.TG.arn
      type             = "forward"
    }

  }


  #to get some information printed on the terminal
  output "loadbalancerdns" {
    value = aws_lb.myalb.dns_name
  }
