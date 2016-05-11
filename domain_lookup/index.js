var fs = require("fs");
var server = require("./server");
var router = require("./router");
var requestHandlers = require("./requestHandlers");
var handle = {};

handle["/"] = requestHandlers.user;
handle["/user"] = requestHandlers.user;
handle["/insert"] = requestHandlers.insert;
handle["/userdetails"] = requestHandlers.userdetails;
handle["/main"] = requestHandlers.main;
handle["/usersearch"] = requestHandlers.usersearch;
handle["/pcsearch"] = requestHandlers.pcsearch;


//handle["/upload"] = requestHandlers.upload;

handle["/favicon.ico"] = requestHandlers.favicon;

fs.readdir("d:\\node\\img\\", function (err, files){

	if (err){
		console.log("err: "+err);
		return;
	}
	for (i in files){
		handle["/img/"+files[i]] =  requestHandlers.img;
	}
});

fs.readdir("d:\\node\\js\\", function (err, files){

	if (err){
		console.log("err: "+err);
		return;
	}
	for (i in files){
		handle["/js/"+files[i]] =  requestHandlers.js;
	}
});

fs.readdir("d:\\node\\css\\", function (err, files){

	if (err){
		console.log("err: "+err);
		return;
	}
	for (i in files){
		handle["/css/"+files[i]] =  requestHandlers.css;
	}
});

fs.readdir("d:\\node\\fonts\\", function (err, files){

	if (err){
		console.log("err: "+err);
		return;
	}
	for (i in files){
		handle["/fonts/"+files[i]] =  requestHandlers.font;
	}
});


server.start(router.route, handle);