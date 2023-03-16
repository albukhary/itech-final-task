###### EBS Volume and attach

# Create an EBS volume
resource "aws_ebs_volume" "node" {
  availability_zone = "${var.region}a"
  size              = 8
  type              = "gp2"
}

# Attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "node" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.node.id
  instance_id = aws_instance.node.id
}
