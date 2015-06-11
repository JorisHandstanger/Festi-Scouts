var Badge = require('../models/Badge.js');

var BadgesCollection = Backbone.Collection.extend({

	model: Badge,
	url: './api/badges',

});

module.exports = BadgesCollection;
