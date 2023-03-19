#!/bin/bash

# Change color to green
echo -e "\033[1;32m"

echo "**************************************************************"
echo "This script resizes the primary EBS volume of an EC2 instance"
echo "**************************************************************"
echo
read -p 'Enter the EC2 instance name (as specified in its 'Name' tag): ' EC2_NAME
echo

# Get the EC2 instance ID based on the Name tag
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$EC2_NAME" --query "Reservations[].Instances[].InstanceId" --output text)

if [ -z "$INSTANCE_ID" ]; then
    echo "EC2 instance with name tag $EC2_NAME not found"
    exit 1
fi

# Get the current size of the instance's primary EBS volume
DEVICE=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[].Instances[].BlockDeviceMappings[].DeviceName[]" --output text)
VOLUME_ID=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[].Instances[].BlockDeviceMappings[].Ebs[].VolumeId[]" --output text)
CURRENT_SIZE=$(aws ec2 describe-volumes --volume-ids $VOLUME_ID --query "Volumes[].Size" --output text)

echo "Current size of EBS volume $VOLUME_ID is $CURRENT_SIZE GiB"
echo

read -p 'Enter the amount of disk space to add in GB: ' ADDITIONAL_SPACE

# Calculate the new size of the instance's primary EBS volume
NEW_SIZE=$(expr $CURRENT_SIZE + $ADDITIONAL_SPACE)

# Resize the instance's primary EBS volume
echo
echo "Resizing EBS volume $VOLUME_ID from $CURRENT_SIZE GiB to $NEW_SIZE GiB"
echo

# Change color to red if error happens
echo -e "\e[31m"
# Modify the size of the EBS volume
if aws ec2 modify-volume --volume-id $VOLUME_ID --size $NEW_SIZE > /dev/null; then
    # Change back to green
    echo -e "\033[1;32m"
    echo -e "Successfully resized the primary EBS volume of instance $EC2_NAME to $NEW_SIZE GiB to the mount point $DEVICE"
else
    echo "Failed to resize the primary EBS volume of instance $EC2_NAME"
    exit 1
fi
