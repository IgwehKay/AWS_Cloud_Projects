Note: All setups must be in the same AWS region
Movies DB setup

Setting up AWS Lambda function
Name: MoviesDB_API
Runtime: Python3.13
Architecture: x86_64
Permission: Create new role from AWS Policy templates
Trusted entity type: AWS_Service
Use case: Lambda
Permissions added: DynamoDBFullAccess, AmazonGatewayInvokeFullAccess, AWSLAmbdaBasicExecutionRole
Rolename: MoviesDB_API_Role

Python code source: movies_db.py

Creating AWS DynamoDB table
Table name: movies
partition key: id 
value" string

Creating API Gateway
API Type: #HTTP
Build configurations:
API name: MoviesDB_API


Configure routes:
Route1
Method: DELETE
Resource path: /movies{id}
Integration target: MoviesDB_API

Route2
Method: GET
Resource path: /movies{id}
Integration target: MoviesDB_API

Route3
Method: GET
Resource path: /movies
Integration target: MoviesDB_API

Route3
Method: POST
Resource path: /movies
Integration target: MoviesDB_API


Python Lambda function code source: employee_db.py