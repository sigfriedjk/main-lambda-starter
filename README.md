# main-lambda-starter

1. `docker build -t aws-lambda-runner .`
2. 
```
docker run --rm \
  -e AWS_ACCESS_KEY_ID=your_access_key_id \
  -e AWS_SECRET_ACCESS_KEY=your_secret_access_key \
  aws-lambda-runner
```