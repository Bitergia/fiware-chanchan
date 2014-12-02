#!/bin/bash

# Subscribe Room context and Room1 entity to notify CKAN on changes
(curl localhost:10026/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "Room",
            "isPattern": "false",
            "id": "Room1" 
        }
    ],
    "attributes": [
        "temperature" 
    ],
    "reference": "http://localhost:5050/notify",
    "duration": "P1M",
    "notifyConditions": [
        {
            "type": "ONCHANGE",
            "condValues": [
                "pressure" 
            ]
        }
    ],
    "throttling": "PT1S" 
}
EOF

# Append sample update context to check CKAN is notified
(curl localhost:10026/NGSI10/updateContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "contextElements": [
        {
            "type": "Room",
            "isPattern": "false",
            "id": "Room1",
            "attributes": [
            {
                "name": "temperature",
                "type": "centigrade",
                "value": "0.01" 
            },
            {
                "name": "pressure",
                "type": "mmHg",
                "value": "720" 
            }
            ]
        }
    ],
    "updateAction": "APPEND" 
}
EOF