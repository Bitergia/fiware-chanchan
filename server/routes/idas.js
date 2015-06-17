/*
 * ChanChan Auth REST API
 */

var utils = require('../utils');
var idas_url = "idas";
var scripts_home = "/home/bitergia/scripts/idas-scripts";
var idas_params = " --idas-host idas --idas-port 8080 ";
var orion_params = " --context-broker-url http://orion:1026 ";
var api_params = " --api-key test ";
var service_params = " --service bitergiaidas --service-path / ";

exports.list_devices = function(req, res) {
    var cmd_list = scripts_home+"/list_devices.sh ";
    cmd_list += idas_params + service_params;
    console.log(cmd_list);

    var exec = require('child_process').exec, child;

    child = exec(cmd_list,
    function (error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log('exec error: ' + error);
      }
      res.send(stdout);
    });
};


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


    var cmd_service = scripts_home+"/create_service.sh ";
    cmd_service += orion_params + idas_params + api_params + service_params;

    var cmd_device = scripts_home+"/create_temp_device.sh ";
    cmd_device += idas_params + service_params;
    // cmd_device += "--device c4:8e:8f:f4:38:2b:Temp_1 ";
    cmd_device += "--device " + device_id + " ";
    cmd_device += "--entity SENSOR_TEMP_"  + device_id;
    console.log(cmd_device);

    var cmd_send = scripts_home+"/send_data.sh ";
    cmd_send += idas_params;
    cmd_send += service_params;
    cmd_send += api_params;
    cmd_send += "--device "+device_id+" "; // c4:8e:8f:f4:38:2b:Temp_1
    // cmd += "--measurement \"t$(./get_temp.sh)\""
    cmd_send += "--measurement \"t|"+ temperature + "\""
    console.log(cmd_send);

    var exec = require('child_process').exec, child;

    // Always try to create the service and the device and then
    // update temperature
    cmd = cmd_service + " && " + cmd_device + " && " + cmd_send;

    child = exec(cmd,
      function (error, stdout, stderr) {
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        if (error !== null) {
          console.log('exec error: ' + error);
        }
        res.send(cmd)
    });
};
