'use strict';
var Alexa = require("alexa-sdk");
var http = require('http');

exports.handler = function(event, context, callback) {
	var alexa = Alexa.handler(event, context);
	alexa.registerHandlers(handlers);
	alexa.execute();
};

var handlers = {
	'LaunchRequest': function () {
		this.emit('Ideate');
	},
	'IdeateIntent': function () {
		this.emit('Ideate')
	},
	'Ideate': function () {
		var options = {
			host: 'ubaas.herokuapp.com',
			path: 'ubaas'
		};
		http.get('http://ubaas.herokuapp.com/ubaas', (response) => {
			var str = '';
			response.on('data', (chunk) => {
				str += chunk;
			});
			response.on('end', () => {
				var data =  JSON.parse(str);
				this.emit(':tell', data['ub'] + '.');
			});
		});
	}
};
