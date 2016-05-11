var http = require("http");
var url = require("url");

function start(route, handle) {
  function onRequest(request, response) {
    var postData = "";
    request.setEncoding("utf8");
    route(url.parse(request.url).pathname, handle, response, postData, url.parse(request.url, true).query, request);
  }

  http.createServer(onRequest).listen(8888);
  console.log("Server has started.");
}

exports.start = start;