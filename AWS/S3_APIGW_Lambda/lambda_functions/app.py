import sys
import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    return {
        "statusCode": 200,
        "body": "Hello Planet Earth",
        'headers' : {
            'Access-Control-Allow-Origin' : '*'
        }
    }