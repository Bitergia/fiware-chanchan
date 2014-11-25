var config = {}

// URL to the FI-WARE Identity Management GE
// default: https://account.lab.fi-ware.org
// config.idm_url = 'https://account.lab.fi-ware.org';
config.idm_url = 'https://idm.shinchan.bitergia.org';

// Oauth2 configuration
// Found on the application profile page after registering
// the application on the FI-WARE Identity Management GE

// Client ID for the application
config.client_id = '3';

// Client Secret for the application
config.client_secret = 'b91f39f836e1cd7d1deae1e0d184ea09976a066bd0a6e4361e8ffe88422bbd677706982fa2feaa85f3bd291e810c30e616a4df10e3e659f823d42e8a5146ba9f';

// Callback URL for the application
config.callback_url = 'http://localhost:3000/login';


module.exports = config;
