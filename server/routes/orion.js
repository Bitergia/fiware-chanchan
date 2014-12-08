/*
 * ChanChan Orion REST API
 */

var utils = require('../utils');
var orion_url = "localhost";



// Return the list of available contexts in Orion
exports.contexts = function(req, res) {
    // TODO: Check auth
    // Is it possible to get all contexts from the API?
    // Right now we get all contexts from a type
    contextType = "Room";


    return_get = function(res, buffer) {
        res.send(buffer);
    };


    var options = {
        host: orion_url,
        port: 10026,
        path: '/NGSI10/contextEntityTypes/'+contextType,
        method: 'GET',
        headers: {
            accept: 'application/json'
        }
    };

    utils.do_get(options, return_get, res); 
};

//Create a new Context in CKAN for an organization
exports.create_context = function(req, res) {
  return_post = function(res, buffer) {
      res.send(buffer);
  };

  var cygnus_ckan_url = "http://localhost";
  var org_id = req.params.org_id;
  var context_id = req.params.context_id;
  var org_port;

    if (org_id == "org1") {
      org_port = "5001";
  } else if (resource_id == "org2") {
      org_port = "5002";
  } else {
      res.status(404);
      res.send(err.message || "Org " + org_id + " not found.");
      return;
  }

  post_data = {
      "entities": [
           {
               "type": context_id,
               "isPattern": "false",
               "id": "FirstEntity"
           }
       ],
       "attributes": [
           "temperature"
       ],
       "reference": cygnus_ckan_url + ":" + org_port +"/notify",
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
  };

  post_data = JSON.stringify(post_data);

  headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Content-Length': post_data.length
  };

  var options = {
      host: orion_url,
      port: 10026,
      path: '/NGSI10/subscribeContext',
      method: 'POST',
      headers: headers
  };

  utils.do_post(options, post_data, return_post, res);
};

// Update entities data (temperature)
exports.update_context = function(req, res) {
  return_post = function(res, buffer) {
      res.send(buffer);
  };

  var org_id = req.params.org_id;
  var context_id = req.params.context_id;
  var temperature_id = req.params.temperature_id;

    post_data = {
        "contextElements": [
                {
                    "type": context_id,
                    "isPattern": "false",
                    "id": "FirstEntity",
                    "attributes": [
                    {
                        "name": "temperature",
                        "type": "centigrade",
                        "value": temperature_id
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
    };


  post_data = JSON.stringify(post_data);

  headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Content-Length': post_data.length
  };

  var options = {
      host: orion_url,
      port: 10026,
      path: '/NGSI10/updateContext',
      method: 'POST',
      headers: headers
  };

  utils.do_post(options, post_data, return_post, res);
};