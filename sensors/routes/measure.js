// Receive a notification an log it in console
exports.notify_get = function(req, res) {
    console.log("[GET] New sensores data " + req);

    res.status(200);
    res.send('{"msg":"Data stored"}');
};

exports.notify_post = function(req, res) {
    console.log("[POST] New sensores data " + req);
    // Processing POST request

    // JSON POST
    console.log(req.body);

    res.status(200);
    res.send('{"msg":"Data stored"}');
};
