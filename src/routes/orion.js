/*
 * ChanChan Orion REST API
 */

var http =    require('http');
var orion_url = "localhost";


// Return the list of available contexts in Orion
exports.contexts = function(req, res) {
    // TODO: Check auth
    // Is it possible to get all contexts from the API?
    // Right now we get all contexts from a type
    contextType = "Room";

    var options = {
        host: orion_url,
        port: 1026,
        path: '/NGSI10/contextEntityTypes/'+contextType,
        method: 'GET',
        headers: {
            accept: 'application/json'
        }
    };

    var request = http.get(options, function (response) {
        // data is streamed in chunks from the server
        // so we have to handle the "data" event
        var buffer = "", data, route;

        response.on("data", function (chunk) {
            buffer += chunk;
        }); 

        response.on("end", function (err) {
            // finished transferring data
            // dump the raw data
            // console.log(buffer);
            // console.log("\n");
            try {
                data = JSON.parse(buffer);
                console.log(data);
            } catch (err) {
                console.log("Can't decode Orion response.");
                console.log(err);
            }
            if (data == undefined) {
                res.send("Error processing Orion response");
            }
            else {
                res.send(buffer);
            }
        });
    }); 
};