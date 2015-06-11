var Handlebars = require("hbsfy/runtime");
var Application = require('./classes/routers/Application.js');

Handlebars.registerHelper("formatDate", function(date) {
	return moment(this.created).fromNow();
});

function init() {
	Window.Application = new Application();
	Backbone.history.start();
}

init();
