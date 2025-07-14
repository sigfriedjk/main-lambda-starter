FROM amazonlinux:2

# Install dependencies and AWS CLI
RUN yum -y update && \
    yum -y install unzip curl python3 && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Set environment variables for AWS credentials (set at runtime)
ENV AWS_ACCESS_KEY_ID=your_access_key_id
ENV AWS_SECRET_ACCESS_KEY=your_secret_access_key
ENV AWS_DEFAULT_REGION=us-east-1

# Command to run when container starts
CMD ["sh", "-c", "aws lambda invoke --function-name arn:aws:lambda:us-east-1:721083415922:function:InstanceStarter --payload '{}' /dev/stdout"]
