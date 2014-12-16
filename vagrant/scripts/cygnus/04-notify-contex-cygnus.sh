#!/bin/bash

# For all the organizations, subscribe to all changes to entities with names manual:*
# To change to params: type:org_name
(curl localhost:10026/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "org_a",
            "isPattern": "true",
            "id": "manual:*"
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

(curl localhost:10026/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "org_b",
            "isPattern": "true",
            "id": "manual:*"
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

# Old organizations name

(curl localhost:10026/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "org1",
            "isPattern": "true",
            "id": "manual:*" 
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

(curl localhost:10026/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "org2",
            "isPattern": "true",
            "id": "manual:*" 
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