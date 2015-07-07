/*
 * Copyright 2014 Telefonica Investigación y Desarrollo, S.A.U
 *
 * This file is part of fiware-iotagent-lib
 *
 * fiware-iotagent-lib is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * fiware-iotagent-lib is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public
 * License along with fiware-iotagent-lib.
 * If not, seehttp://www.gnu.org/licenses/.
 *
 * For those usages not covered by the GNU Affero General Public License
 * please contact with::[contacto@tid.es]
 */

var config = {};

config.lwm2m = {
    logLevel: 'DEBUG',
    port: 60001,
    defaultType: 'Device',
    ipProtocol: 'udp4',
    serverProtocol: 'udp4',
    formats: [
	{
	    name: 'application-vnd-oma-lwm2m/text',
	    value: 1541
	},
	{
	    name: 'application-vnd-oma-lwm2m/tlv',
	    value: 1542
	},
	{
	    name: 'application-vnd-oma-lwm2m/json',
	    value: 1543
	},
	{
	    name: 'application-vnd-oma-lwm2m/opaque',
	    value: 1544
	}
    ],
    writeFormat: 'application-vnd-oma-lwm2m/text',
    types: [ ]
};

config.ngsi = {
    logLevel: 'DEBUG',
    contextBroker: {
	host: 'ORION_HOSTNAME',
	port: 'ORION_PORT'
    },
    server: {
	port: IOTA_SERVER_PORT
    },
    deviceRegistry: {
	type: 'mongodb',
	host: 'MONGODB_HOSTNAME',
	port: 'MONGODB_PORT',
	db: 'MONGODB_DATABASE'
    },
    types: { },
    service: 'IOTA_DEFAULT_SERVICE',
    subservice: 'IOTA_DEFAULT_SUBSERVICE',
    providerUrl: 'http://192.168.56.1:4041',
    deviceRegistrationDuration: 'P1M'
};

module.exports = config;
