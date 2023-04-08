import os
import json
from flask import Flask, request, jsonify
from github import Github

app = Flask(__name__)

def create_terraform_file(payload):
    properties = payload["payload"]["properties"]
    
    terraform_file = f"""
provider "aws" {{
  region = "{properties['aws-region']}"
}}

resource "aws_s3_bucket" "example" {{
  bucket = "{properties['bucket-name']}"
}}

resource "aws_s3_bucket_public_access_block" "example_public_access_block" {{
  bucket_name = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}}
"""
    return terraform_file

@app.route('/terraform', methods=['POST'])
def terraform():
    payload = request.get_json()
    terraform_file = create_terraform_file(payload)

    GITHUB_ACCESS_TOKEN = os.environ['GITHUB_ACCESS_TOKEN']
    REPO_NAME = "justmy2centx/tf-parser"

    pr_number = create_branch_and_pr(terraform_file, GITHUB_ACCESS_TOKEN, REPO_NAME)

    return {'status': 'success', 'pr_number': pr_number}, 200

def create_branch_and_pr(terraform_file, access_token, repo_name):
    g = Github(access_token)
    repo = g.get_repo(repo_name)

    base_branch = repo.get_branch("main")
    new_branch_name = f"aws-s3-bucket-pr{repo.get_pulls().totalCount + 1}"
    new_branch_ref = f"refs/heads/{new_branch_name}"

    repo.create_git_ref(ref=new_branch_ref, sha=base_branch.commit.sha)
    
    file_name = "aws_s3_bucket.tf"
    commit_message = f"Add {file_name}"
    dir_name = "terraform_s3_buckets"

    if not any(file.name == dir_name for file in repo.get_contents("")):
        repo.create_file(f"{dir_name}/README.md", "Initial commit", "")
        
    repo.create_file(file_name, commit_message, terraform_file, branch=new_branch_name)

    pr_title = f"Add {file_name}"
    pr_body = f"PR for adding {file_name}"
    pr = repo.create_pull(title=pr_title, body=pr_body, head=new_branch_name, base="main")

    return pr.number

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5005')
