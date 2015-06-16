/*
 * ChanChan Auth REST API
 */

var utils = require('../utils');
var idas_url = "idas";

exports.update_temperature = function(req, res) {
    return_post = function(res, buffer) {
        try {
            var token = buffer;
            res.send(buffer);
        } catch (e) {
            res.status(403);
            res.send(buffer);
        };
    };

    var device_id = req.params.device_id;
    var temperature = req.params.temperature;
    res.send("OK")
};
