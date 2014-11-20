var express = require('express');
var app = express();

app.use(express.logger());
app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({secret: '08bf59703922c49573f008b4ce58b5b0'}));
app.configure(function () {
    "use strict";
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
    app.use(express.static(__dirname + '/public'));
});

var auth = require('./auth');
var site = require('./site');
//var user = require('./user');

// main page
app.get('/', site.index);
app.get('/login',auth.login);
app.get('/logout',auth.logout);
app.get('/auth',auth.auth);

// start server
app.set('port', process.env.PORT || 3000);
var server = app.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + server.address().port);
});
