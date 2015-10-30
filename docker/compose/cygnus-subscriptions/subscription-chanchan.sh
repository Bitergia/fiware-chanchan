CYGNUS_HOSTNAME=`hostname -i` # can't link orion to cygnus (circular link in docker). Use IP

    echo "subscribing to orion chanchanapp"
    # For all the organizations, subscribe to all changes to entities with names manual:*
    # To change to params: type:org_name
    cat <<EOF | curl ${ORION_HOSTNAME}:${ORION_PORT}/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @-
{
    "entities": [
	{
	    "type": "orga_a",
	    "isPattern": "true",
	    "id": "manual:*"
	}
    ],
    "attributes": [
	"temperature"
    ],
    "reference": "http://${CYGNUS_HOSTNAME}:5001/notify",
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

    echo "subscribing to orion"
    cat <<EOF | curl ${ORION_HOSTNAME}:${ORION_PORT}/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @-
{
    "entities": [
	{
	    "type": "orga_b",
	    "isPattern": "true",
	    "id": "manual:*"
	}
    ],
    "attributes": [
	"temperature"
    ],
    "reference": "http://${CYGNUS_HOSTNAME}:5002/notify",
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

    echo "subscribing to orion"
    # Santander sensors
    cat <<EOF | curl ${ORION_HOSTNAME}:${ORION_PORT}/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @-
{
    "entities": [
	{
	    "type": "santander:soundacc",
	    "isPattern": "true",
	    "id": "urn:smartsantander:testbed:*"
	}
    ],
    "reference": "http://${CYGNUS_HOSTNAME}:5050/notify",
    "duration": "P1M",
    "notifyConditions": [
	{
	    "type": "ONCHANGE",
	    "condValues": [
		"TimeInstant"
	    ]
	}
    ]
}
EOF

    echo "subscribing to orion"
    # IDAS temperature sensors
    cat <<EOF | curl ${ORION_HOSTNAME}:${ORION_PORT}/NGSI10/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' -d @-
{
    "entities": [
	{
	    "type": "thing",
	    "isPattern": "true",
	    "id": "SENSOR_TEMP:*"
	}
    ],
    "attributes": [
	"temperature"
    ],
    "reference": "http://${CYGNUS_HOSTNAME}:6001/notify",
    "duration": "P1M",
    "notifyConditions": [
	{
	    "type": "ONCHANGE",
	    "condValues": [
		"TimeInstant"
	    ]
	}
    ],
    "throttling": "PT1S"
}
EOF
