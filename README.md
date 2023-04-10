# tf-parser


Merge and push to main automatically builds the container and push the image to ECR and deploy to EKS.

In order to test, you can run this sample curl command. Make sure to put a unique bucket name.

```
curl -X POST -H "Content-Type: application/json" -d '{"payload": {"properties": {"aws-region": "us-west-2", "bucket-name": "your_unique_bucket_name_here"}}}' http://tf-parser-app.reliableweb.info/terraform
```

To answer some of the questions in the take home test pdf:

CI
How to build up the container image
- Already part of the Github Actions
CD
How to apply new image tag after service update
- Already part of the Github Actions
How to apply terraform file after PR merge
- We can create a Github action if condition is met (e.g. merged to main) we can use terraform binary and do plan and apply from GHA.
Monitoring
- We can monitor the number of 5xx/4xx calls to the endpoint using ingress nginx prometheus exporter. We can also monitor the usual cpu usage
What kind of log to need be logged
- The logs of every calls to the rest api endpoint and if pod crashes. All errors.
What kind of metrics need to be monitoring
- 5xx/4xx failed attempts to the rest api 
Scale strategy
- we can scale based on cpu or mem usage and create an HPA to scale the pods automatically.
What is your scale policy.
- we can scale based on cpu or mem usage and create an HPA to scale the pods automatically.

