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
        port: 1026,
        path: '/NGSI10/contextEntityTypes/'+contextType,
        method: 'GET',
        headers: {
            'accept': 'application/json',
            'fiware-service': '',
            'fiware-servicepath': '',
            'x-auth-token':''
        }
    };

    utils.do_get(options, return_get, res); 
};
