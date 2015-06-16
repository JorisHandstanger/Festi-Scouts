var Badge = require('../models/Badge.js');

var BadgesCollection = Backbone.Collection.extend({

	model: Badge,
	url: './api/badges',

	initialize: function (options) {
		if (options) {
			this.id = options.id
		};
	},

	methodUrl: function  (method) {
		if (method === "read" && this.id) {
			this.url = "./api/badges/" + this.id;
			return;
		}
		this.url = "./api/badges";
	},

		sync: function(method, model, options) {
		if(model.methodUrl && model.methodUrl(method.toLowerCase())) {
			options = options || {};
			options.url = model.methodUrl(method.toLowerCase());
		}
    Backbone.Collection.prototype.sync.apply(this, arguments);
	}

});

module.exports = BadgesCollection;
