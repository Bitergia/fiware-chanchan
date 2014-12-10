
var express = require('express'),
    measure = require('./routes/measure');

var app = express();

app.use(express.logger());
app.use(express.bodyParser());
app.configure(function () {
    "use strict";
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.get('/api/measure', measure.notify_get);
app.post('/api/measure', measure.notify_post);

app.get('*', function(req, res, next) {
    var err = new Error();
    err.status = 404;
    next(err);
});

app.use(function(err, req, res, next) {
    if (err.status !== 404) {
	    return next();
    }

    res.status(404);
    res.send(err.message || "ups!");
});

// start server
app.set('port', process.env.PORT || 30000);
var server = app.listen(app.get('port'), function() {
    console.log('Sensores hub listening on port ' + app.get('port'));
});
