import json
import boto3
from decimal import Decimal

# Initialize DynamoDB client and resource
client = boto3.client('dynamodb')
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('movies')
tableName = 'movies'

def lambda_handler(event, context):
    print(event)
    body = {}
    statusCode = 200
    headers = {
        "Content-Type": "application/json"
    }

    try:
        # DELETE a movie by ID
        if event['routeKey'] == "DELETE /movies/{id}":
            table.delete_item(
                Key={'id': event['pathParameters']['id']}
            )
            body = f"Deleted movie with ID {event['pathParameters']['id']}"

        # GET a single movie by ID
        elif event['routeKey'] == "GET /movies/{id}":
            response = table.get_item(
                Key={'id': event['pathParameters']['id']}
            )
            if 'Item' in response:
                movie = response["Item"]
                body = {
                    'id': movie['id'],
                    'title': movie['title'],
                    'year': int(movie['year']),
                    'rating': float(movie['rating'])
                }
            else:
                statusCode = 404
                body = f"Movie with ID {event['pathParameters']['id']} not found"

        # GET all movies
        elif event['routeKey'] == "GET /movies":
            response = table.scan()
            movies = response.get("Items", [])
            body = [
                {
                    'id': movie['id'],
                    'title': movie['title'],
                    'year': int(movie['year']),
                    'rating': float(movie['rating'])
                }
                for movie in movies
            ]

        # POST (Add a new movie)
        elif event['routeKey'] == "POST /movies":
            requestJSON = json.loads(event['body'])
            table.put_item(
                Item={
                    'id': requestJSON['id'],
                    'title': requestJSON['title'],
                    'year': int(requestJSON['year']),
                    'rating': Decimal(str(requestJSON['rating']))
                }
            )
            body = f"Added movie '{requestJSON['title']}' (ID: {requestJSON['id']})"

    except KeyError:
        statusCode = 400
        body = f"Unsupported route: {event['routeKey']}"

    # Format response
    body = json.dumps(body)
    return {
        "statusCode": statusCode,
        "headers": headers,
        "body": body
    }