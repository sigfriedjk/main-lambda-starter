FROM amazonlinux:2

# Install dependencies, AWS CLI, and JQ
RUN yum -y update && \
    yum -y install unzip curl python3 jq && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

ENV AWS_DEFAULT_REGION=us-east-1

ENTRYPOINT ["aws"]
CMD ["help"]