# Build the Docker image
docker build -t my-terraform-app .

# Run the Docker container
docker run -d -p 5000:5000 --env-file=.env my-terraform-app



REPO_NAME = "justmy2centx/tf-parser"

curl -X POST -H "Content-Type: application/json" -d '{"payload": {"properties": {"aws-region": "eu-west-1", "bucket-name": "tripla-bucket"}}}' http://localhost:5001/terraform

