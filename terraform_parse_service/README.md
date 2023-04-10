# Build the Docker image
docker build -t terraform-parsing-service .

# Run the Docker container
docker-compose up --build --force-recreate

# Pre requisite to build app and run in docker compose
export GITHUB_ACCESS_TOKEN=your_github_personal_access_token

# Pre requisite to run the terraform code in /eks

Configure using `aws configure` with your access and secret keys.