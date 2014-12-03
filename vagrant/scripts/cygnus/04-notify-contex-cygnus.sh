#!/bin/bash

# org1: Subscribe Room context and Room1 entity to notify CKAN on changes
(curl localhost:10026/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "org1Room",
            "isPattern": "false",
            "id": "Room1"
        }
    ],
    "attributes": [
        "temperature"
    ],
    "reference": "http://localhost:5001/notify",
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

# org2: Subscribe Room context and Room1 entity to notify CKAN on changes
(curl localhost:10026/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "org2Room",
            "isPattern": "false",
            "id": "Room1"
        }
    ],
    "attributes": [
        "temperature"
    ],
    "reference": "http://localhost:5002/notify",
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

# org1: Append sample update context to check CKAN is notified
(curl localhost:10026/NGSI10/updateContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "contextElements": [
        {
            "type": "org1Room",
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

# org2: Append sample update context to check CKAN is notified
(curl localhost:10026/NGSI10/updateContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "contextElements": [
        {
            "type": "org2Room",
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