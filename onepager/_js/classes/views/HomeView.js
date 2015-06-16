var template = require('../../../_hbs/home.hbs');
var geenlidview = require('../views/geenLidView.js');
var lidview = require('../views/lidView.js');
var HomeView = Backbone.View.extend({

	template: template,
	tagName: 'section',

	events: {
		'mouseover .yes': 'hoverYes',
		'mouseover .no': 'hoverNo',
		'mouseout .yes': 'hoverYes',
		'mouseout .no': 'hoverNo',
		'click .yes': 'yesPressed',
		'click .no': 'noPressed'
	},

	initialize: function() {

	},

	render: function() {
		this.$el.html(this.template());

		return this;
	},

	hoverYes: function(){
		$(".roulette").toggleClass("rouletteHover")
		$(".roulette").toggleClass("rotateClockwise")
	},

	hoverNo: function(){
		$(".roulette").toggleClass("rouletteHover")
		$(".roulette").toggleClass("rotateCounterClockwise")
	},

	yesPressed: function(){
		event.preventDefault();
		$(".panel").toggleClass("opened")
		$(".roulette").toggleClass("hidden")

		this.lidview = new lidview();
		$('.panel').append(this.lidview.render().el);
		console.log("Lid")
	},

	noPressed: function(){
		event.preventDefault();
		$(".panel").toggleClass("opened")
		$(".roulette").toggleClass("hidden")

		this.geenlidview = new geenlidview();
		$('.panel').append(this.geenlidview.render().el);
		console.log("Geen lid")
	},

});

module.exports = HomeView;
