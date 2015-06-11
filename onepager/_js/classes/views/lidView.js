var template = require('../../../_hbs/lid.hbs');

var lidView = Backbone.View.extend({

	template: template,
	tagName: 'main',
	className: "cd-main-content",

	events: {

	},

	initialize: function(){

		this.render();

	},

	render: function(){

		this.$el.html(this.template());
		return this;

	}

});

module.exports = lidView;
