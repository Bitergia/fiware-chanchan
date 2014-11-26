/*
 * ChanChan Utils
 */

http = require('http');

exports.do_get = function (options, callback, res) {
    var request = http.get(options, function (response) {
        // data is streamed in chunks from the server
        // so we have to handle the "data" event
        var buffer = "", data, route;

        response.on("data", function (chunk) {
            buffer += chunk;
        });

        response.on("end", function (err) {
            var msg = "";
            try {
                data = JSON.parse(buffer);
                console.log(data);
            } catch (err) {
                console.log("Can't decode CKAN response.");
                console.log(err);
                msg = "Can't decode CKAN response.";
            }
            if (data == undefined) {
                msg = "Error processing CKAN response";
            }
            else {
                msg = buffer;
            }
            callback(res, msg)
        });
    }); 
}