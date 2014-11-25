/*
 * ChanChan CKAN REST API
 */

var utils = require('../utils');
var ckan_url = "demo.ckan.org";

// Return the list of available datasets in CKAN site
exports.datasets = function(req, res) {
    return_get = function(res, buffer) {
        res.send(buffer);
    };

    var options = {
        host: ckan_url,
        port: 80,
        path: '/api/action/package_list',
        method: 'GET'
    };

    utils.do_get(options, return_get, res);
};

//Return the list of available organizations
exports.organizations = function(req, res) {
    return_get = function(res, buffer) {
        res.send(buffer);
    };

    var options = {
        host: ckan_url,
        port: 80,
        path: '/api/action/organization_list',
        method: 'GET'
    };

    utils.do_get(options, return_get, res);
};