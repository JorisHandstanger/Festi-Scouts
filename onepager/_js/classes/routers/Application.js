var HomeView = require("../views/HomeView.js")

var Application = Backbone.Router.extend({
routes:  {
		"home" : "home",
		"*actions" : "default"
	},

	default: function() {
		this.navigate("home",{trigger:true});
	},

	empty: function() {
		$(".container").empty();
	},

	home: function() {
		console.log("[Home]");
		this.empty()
		this.homeview = new HomeView();
		$(".container").append(this.homeview.render().el);
	}

});

module.exports = Application;
