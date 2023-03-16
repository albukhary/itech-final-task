resource "aws_launch_template" "example" {
  name_prefix   = "example"
  instance_type = aws_instance.node.instance_type
  image_id      = var.ami_id
  key_name      = aws_instance.node.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = aws_instance.node.root_block_device[0].volume_size
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "EKS-Node"
    }
  }
}