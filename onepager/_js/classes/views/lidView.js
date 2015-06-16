var template = require('../../../_hbs/lid.hbs');
var BadgesCollection = require('../collections/BadgesCollection.js');

var lidView = Backbone.View.extend({

	template: template,
	tagName: 'main',
	className: "cd-main-content",

	events: {
		"click .add": "clickAdd",
	},

	initialize: function(){

		this.render();

	},

	render: function(){

		this.$el.html(this.template());
		return this;

	},

	byUser: function(){

	}

});

module.exports = lidView;
