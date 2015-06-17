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

    var scripts_home = "/home/bitergia/scripts/idas-scripts";
    var idas_params = " --idas-host idas --idas-port 8080 ";
    var orion_params = " --context-broker-url http://orion:1026 ";
    var api_params = " --api-key test ";
    var service_params = " --service bitergiaidas --service-path / ";

    var cmd_service = scripts_home+"/create_service.sh ";
    cmd_service += orion_params + idas_params + api_params + service_params;
    console.log(cmd_service);

    var cmd_device = scripts_home+"/create_temp_device.sh ";
    cmd_device += idas_params + service_params;
    cmd_device += "--device c4:8e:8f:f4:38:2b:Temp_1 ";
    cmd_device += "--entity SENSOR_TEMP_c4_8e_8f_f4_38_2b_Temperature_Sensor_1";
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

    child = exec(cmd_send,
      function (error, stdout, stderr) {
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        if (error !== null) {
          console.log('exec error: ' + error);
        }
        res.send(cmd_send)
    });
};
