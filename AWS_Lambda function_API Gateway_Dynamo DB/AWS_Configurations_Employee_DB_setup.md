Employee DB setup

Creating AWS Dynamo Table
Table name: employee_info
Table settings: Default settings


Creating AWS Lambda Function
Author from Scratch
Function name: api-processing
Runtime: Python3.11
Execution Role: Create a new role from AWS Policy templates.
Role name: serverless-api-demo 
Permissions: DynamoDBFullAccess, CloudWatchLogFullAcess, AWSLambdaExecutionRole(Added by default)

Creating API Gateway
Type: REST API
Build configurations:
API Name: serverless-demo
API endpoint type: Regional

Creating API Gateway Resources (for the serverless-demo API)
Resource1
Resource details:
Path: /
Resource name: status
Check the CORS (Cross Origin Resource Sharing) box 

Creating method for the status resource
Method1 details:
Type: GET
Integration Type: Lambda function
Activate the Lambda Proxy integration button
Region: us-east-1
Select lambda function: api-processing

Resource2
Resource details:
Path: /
Resource name: employee
Check the CORS (Cross Origin Resource Sharing) box 

Creating method for the employee resource
Method1 details:
Type: GET
Integration Type: Lambda function
Activate the Lambda Proxy integration button
Region: us-east-1
Select lambda function: api-processing

Method2 details:
Type: PATCH
Integration Type: Lambda function
Activate the Lambda Proxy integration button
Region: us-east-1
Select lambda function: api-processing

Method3 details:
Type: POST
Integration Type: Lambda function
Activate the Lambda Proxy integration button
Region: us-east-1
Select lambda function: api-processing

Method4 details:
Type: DELETE
Integration Type: Lambda function
Activate the Lambda Proxy integration button
Region: us-east-1
Select lambda function: api-processing

Resource3
Resource details
Path: /
Resource name: employees
Check the CORS (Cross Origin Resource Sharing) box 

Creating method for the employees resource
Method1 details:
Type: GET
Integration Type: Lambda function
Activate the Lambda Proxy integration button
Region: us-east-1
Select lambda function: api-processing

Deploy API
Stage: New Stage
Stage name: production