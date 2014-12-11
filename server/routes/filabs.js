/*
 * ChanChan CKAN REST API
 */

var utils = require('../utils');
var filabs_url = "cloud.lab.fi-ware.org";

// Return the list of available datasets in CKAN site
exports.auth = function(req, res) {
    return_post = function(res, buffer) {
        try {
            var data = JSON.parse(buffer);
            var token = data.access.token.id;
            res.send(token);
        } catch (e) {
            res.status(403);
            res.send(buffer);
        };
    };

    var auth_data = req.params.auth_data;
    var user = auth_data.split("&")[0];
    var password = auth_data.split("&")[1];

    var post_data = {
        "auth": {
            "passwordCredentials": {
                "username":user,
        		"password":password
    		}
        }
    };

    post_data = JSON.stringify(post_data);

    console.log(post_data);

    var headers = {
        "Content-type":"application/json"
    };

    var options = {
        host: filabs_url,
        port: 4730,
        path: '/v2.0/tokens',
        method: 'POST',
        headers: headers
    };

    utils.do_post(options, post_data, return_post, res);
};