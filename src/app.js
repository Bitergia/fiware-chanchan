
var express = require('express'),
    auth =    require('./auth'),
    site =    require('./site'),
    orion =    require('./routes/orion');

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

// main page
app.get('/', site.index);
app.get('/login',auth.login);
app.get('/logout',auth.logout);
app.get('/auth',auth.auth);


// api rest: /api/
//
// orion
app.get('/api/orion/contexts',orion.contexts);
// ckan
// end api rest


// start server
app.set('port', process.env.PORT || 3000);
var server = app.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + server.address().port);
});