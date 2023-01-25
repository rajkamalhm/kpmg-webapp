# HackerNews scraper deployed in AWS using Terraform
A Webapp to get the top 20 articles from HackerNews deployed in Amazon Web Services through Terraform  

## Steps to deploy
1. Build the docker image using the Dockerfile in the *app* directory.
2. Tag it and push it to dockerhub.
3. Run terraform init, plan and apply in the *deploy-infra* directory.
4. No specific authentication or backend is configured. Hence local backend is used and authentication with AWS happens using the default profile confiured in the local machine or using environment variables.

## About the components
* AWS ECS with Fargate is used as the compute layer for the application
* Dockerhub is used as the container registry
* Application load balancer is used for routing traffic to ECS instances

## Scope for further development
* The architecture was designed as a starting point for a deeper discussion and it is no where near production ready.
* Below steps can be taken to improve the availability, reliability, scalability and ease of operation.
* AWS code build can be used for continuous deployment and promote the application through dev, test and prod.
* It can also be used to build, test and upload the image to ECR.
* Assign a meaningful domain in route 53 for the ALB DNS.
* Here public subnet is used because the image needs to be pulled from dockerhub. It can be converted to private subnet and made to pull images from ECR (through vpc endpoints - private link)
* Terraform backend can be configured with S3 and locking enabled through dynamo DB to prevent loss or corruption of state file
* Cloudfront can be configured to reduce load on the containers. It also helps to absorb certain threats like DDoS.
* Attach a Web Application Firewall to the Load Balancer to prevent SQL injection and enable IP and host header based fitering on incoming requests.
* WAF can also help to configure rate limiting to prevent malicious users from flooding the application with traffic.
* The ALB has built-in scalability and reliability. Load testing the application and configuring the maximum number of tasks for the service in ECS enables us to achieve sclability and reliability for the application as well.
* Fargate can be configured with a minimum number of on-demand instances and more of spot instances to achive cost efficiency and reliability at the same time.