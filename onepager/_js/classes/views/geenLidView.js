var template = require('../../../_hbs/geenlid.hbs');

var geenLidView = Backbone.View.extend({

	template: template,
	tagName: 'main',

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

module.exports = geenLidView;
