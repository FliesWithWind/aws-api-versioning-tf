import os
import json
 
def lambda_handler(event, context):
    json_region = os.environ['AWS_REGION']
    print('pong')
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": "pong-v2"
    }