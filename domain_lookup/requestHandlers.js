var fs = require('fs');
var url = require("url");
var path = require("path");
var mybase = require('./mybase.js');  


function makeuserresponse(response, body) {
	response.writeHead(200, {
		"Content-Type": "text/html"
	});
	response.write(body);
	response.end();
}

function user(response, postData, queryData, request) {
	var fs = require("fs");
	var buf = request.connection.remoteAddress + ";"+queryData.username+";\n";
	fs.appendFile("d:/node/userquery.log",buf);

	var q_body = "";
	var body = '<!DOCTYPE html><html>' +
		'<head>' +
		'<title>ogk-3 users</title>' +
		'<meta http-equiv="Content-Type" content="text/html; ' +
		'charset=utf-8" />' +
		'<link href="/css/my.css" rel="stylesheet">' +
		'</head>' +
		'<body>' +
		'<div class="header">' +
		'<label><p><b>Поиск ПК пользователя по имени/логину/телефону/почте/кабинету:</b><br>' +
		'<form class="fixedform"action="/user" method="get">' +
		'<input type="text" autofocus name="username" ';
	if (queryData.username) {
		body += 'value = "' + queryData.username + '"';
	}
	body += ' />' +
		'<input type="submit" value = "искать"/>' +
		'</form></div><br></label>	';
	if (queryData.username) {

		var mysql = require('mysql');
		var connection = mysql.createConnection(mybase.connection_data);
		connection.connect(function(err) {
			if (err) {
				console.log("Error connecting: " + err);
				body += '<p>Error connecting: ' + err + '<p><br>';
				body += '</body>' +
					'</html>';
				makeuserresponse(response, body);
				return;
			}
			var sql = "select name, fullname, mail, phone, office from ad_info where (name like '%" + queryData.username + "%') or (fullname like '%" + queryData.username + "%') or (mail like '%" + queryData.username + "%') or (office like '%" + queryData.username + "%') or (phone like '%" + queryData.username + "%')";
			connection.query(sql, function(err, result) {
				if (err) {
					console.log("Error query 1: " + err);
					body += '<p>error: ' + err + '<p><br>';
					body += '</body>' +
						'</html>';
					makeuserresponse(response, body);
					connection.end(function(err) {});
				} else {
					if (result.length === 0) {
						body += '<p class="redp">ничего не найдено' + '</p><br>';
						body += '</body>' +
							'</html>';
						makeuserresponse(response, body);
						connection.end(function(err) {});
						return;
					}
					var subq = result.length;
					var q_body = result.slice();
					for (var i = 0; i < result.length; i++) {
						var sql2 = "select " + i + " as idx, user, machine, ip, DATE_FORMAT(time,'%d.%m.%y в %k:%i')as s_time from logons where (user = '" + result[i].name + "')order by time desc";
						connection.query(sql2, function(err, result) {
							if (err) {
								console.log("Error query 2: " + err);
								body += '<p>error: ' + err + '</p>';
								body += '</body>' +
									'</html>';
								makeuserresponse(response, body);
								connection.end(function(err) {});
							} else {
								if (result.length !== 0) {
									body += '<div class="search_result"><h4><a title="Посмотреть подробную информацию" href="/user?username=' + q_body[result[0].idx].mail + '"">' + q_body[result[0].idx].name;
									body += ', ' + q_body[result[0].idx].fullname;
									body += ', ' + q_body[result[0].idx].mail;
									body += ', ' + q_body[result[0].idx].phone;
									body += ', ' + q_body[result[0].idx].office + '</h4></a>';
									body += '<ol>';
									for (var j = 0; j < result.length; j++) {
										body += '<li>' + result[j].machine + "";
										body += ' IP="' + result[j].ip + '", ';
										body += ' заходил(а) ' + result[j].s_time + '</li>';
									}
									body += '</ol></div>';
								} else {

								}
								subq = subq - 1;
								if (subq === 0) {
									connection.end(function(err) {});
									body += '</body>' +
										'</html>';
									makeuserresponse(response, body);
								}
							} 
						}); 
					} 
				}; 
			}); 
		}); 

	} else { 
		body += '</body>' +
			'</html>';
		makeuserresponse(response, body);
	}
}

function insert(response, postData, queryData, request) {
	response.writeHead(200, {
		"Content-Type": "text/plain"
	});
	response.write("inserting...");

	var q_user = queryData.user;
	var q_ip = request.connection.remoteAddress;

	var q_machine = queryData.machine;
	var q_fullname = queryData.fullname;
	var q_time = new Date();

	if ((q_user !== undefined) && (q_ip !== undefined) && (q_machine !== undefined) && (q_fullname !== undefined)) {

		var mysql = require('mysql');

		var connection = mysql.createConnection(mybase.connection_data);

		connection.connect(function(err) {

			if (err) {
				response.write("connect error" + err);
				console.log("error connecting: " + err);
				response.end();
				return;
			}

			response.write("connected as id " + connection.threadId);

			var ins = {
				user: q_user,
				ip: q_ip,
				machine: q_machine,
				time: q_time,
				fullname: q_fullname
			};
			var sql = "INSERT INTO logons SET ?";
			console.log("Inserting: " + q_user + " " + q_machine);

			connection.query(sql, ins, function(err, result) {
				if (err) {
					console.log(err);
				} else {
					console.log(result.insertId);
				}
			});

			connection.end(function(err) {});

		});
	}
	response.end();
}

function upload(response, postData, queryData, request) {
	response.writeHead(200, {
		"Content-Type": "text/plain"
	});
	response.write("Hello Upload " + querystring.parse(postData).text);
	response.end();
	console.log("Request handler 'upload' was called.");
}

function css(response, postData, queryData, request) {
	var fs = require("fs");
	response.writeHead(200, {
		"Content-Type": "text/css"
	});
	response.write(fs.readFileSync("\css\\my.css"));
	response.end();
}

function userdetails(response, postData, queryData, request) {
	var q_body = "";
	var body = '<!DOCTYPE html><html>' +
		'<head>' +
		'<title>ogk-3 users</title>' +
		'<meta http-equiv="Content-Type" content="text/html; ' +
		'charset=utf-8" />' +
		'<link href="/css/my.css" rel="stylesheet">' +
		'</head>' +
		'<body>' +
		queryData.username +
		'<p>not implemendet yet</p></body>';
	makeuserresponse(response, body);

}

function main(response, postData, queryData, request) {
	var fs = require("fs");
	response.writeHead(200, {
		"Content-Type": "text/html"
	});
	response.write(fs.readFileSync("\main.html"));
	response.end();
}

function img(response, postData, queryData, request) {
	var fs = require("fs");
	response.writeHead(200, {
		"Content-Type": "image/png"
	});
	response.write(fs.readFileSync("d:/node/" + url.parse(request.url).pathname));
	response.end();
}

function css(response, postData, queryData, request) {
	var fs = require("fs");
	response.writeHead(200, {
		"Content-Type": "text/css"
	});
	response.write(fs.readFileSync("d:/node/" + url.parse(request.url).pathname));
	response.end();
}

function js(response, postData, queryData, request) {
	var fs = require("fs");
	response.writeHead(200, {
		"Content-Type": "application/javascript"
	});
	response.write(fs.readFileSync("d:/node/" + url.parse(request.url).pathname));
	response.end();
}

function font(response, postData, queryData, request) {
	var fs = require("fs");
	var ct = "";
	var ext = path.extname(url.parse(request.url).pathname);
	switch (ext) {
		case ".woff":
			ct = "application/font-woff";
			break;
		case ".ttf":
			ct = "application/x-font-ttf";
			break;
		case ".svg ":
			ct = "image/svg+xml";
			break;
		case ".eot ":
			ct = "application/vnd.ms-fontobject";
			break;
		default:
			ct = "application/font";
			break;
	}

	response.writeHead(200, {
		"Content-Type": ct
	});

	response.write(fs.readFileSync("d:/node/" + url.parse(request.url).pathname));
	response.end();
}

function favicon(response, postData, queryData, request) {
	var fs = require("fs");
	response.writeHead(200, {
		"Content-Type": "image/png"
	});
	response.write(fs.readFileSync("\img\\kgres.ico"));
	response.end();
}

function usersearch(response, postData, queryData, request) {
	var q_body = "";
	var body = '';
	if (queryData.username) {

		var mysql = require('mysql');
		var connection = mysql.createConnection(mybase.connection_data);
		connection.connect(function(err) {
			if (err) {
				console.log("Error connecting: " + err);
				body += '<p>Error connecting: ' + err + '<p>';
				makeuserresponse(response, body);
				return;
			}
			var sql = "select name, fullname, mail, phone from ad_info where (name like '%" + queryData.username + "%') or (fullname like '%" + queryData.username + "%') or (mail like '%" + queryData.username + "%') or (phone like '%" + queryData.username + "%')";
			connection.query(sql, function(err, result) {
				if (err) {
					console.log("Error query 1: " + err);
					body += '<p>error: ' + err + '<p>';
					makeuserresponse(response, body);
					connection.end(function(err) {});
				} else {
					if (result.length === 0) {
						body += '<p class="redp">ничего не найдено' + '</p>';
						makeuserresponse(response, body);
						connection.end(function(err) {});
						return;
					}
					var subq = result.length;
					var q_body = result.slice();
					for (var i = 0; i < result.length; i++) {
						var sql2 = "select " + i + " as idx, user, machine, ip, DATE_FORMAT(time,'%d.%m.%y в %k:%i')as s_time from ogk3users.logons where (user = '" + result[i].name + "')order by time desc";
						connection.query(sql2, function(err, result) {
							if (err) {
								console.log("Error query 2: " + err);
								body += '<p>error: ' + err + '</p>';
								makeuserresponse(response, body);
								connection.end(function(err) {});
							} else {
								if (result.length !== 0) {
									body += '<div class="user_details"><h4><a title="Посмотреть подробную информацию" href="/userdetails?username=' + q_body[result[0].idx].name + '"">' + q_body[result[0].idx].name;
									body += ', ' + q_body[result[0].idx].fullname;
									body += ', ' + q_body[result[0].idx].mail;
									body += ', ' + q_body[result[0].idx].phone + '</h4></a>';
									body += '<ol>';
									for (var j = 0; j < result.length; j++) {
										body += '<li>' + result[j].machine + "";
										body += ' IP="' + result[j].ip + '", ';
										body += ' заходил(а) ' + result[j].s_time + '</li>';
									}
									body += '</ol></div>';
								} else {

								}
								subq = subq - 1;
								if (subq === 0) {
									connection.end(function(err) {});
									makeuserresponse(response, body);
								}
							} 
						}); 
					} 
				}; 
			}); 
		}); 

	} else {
		makeuserresponse(response, body);
	}
}

function pcsearch(response, postData, queryData, request) {
	
	var q_body = "";
	var body = '';
	if (queryData.username) {

		var mysql = require('mysql');
		var connection = mysql.createConnection(mybase.connection_data);
		connection.connect(function(err) {
			if (err) {
				console.log("Error connecting: " + err);
				body += '<p>Error connecting: ' + err + '<p>';
				makeuserresponse(response, body);
				return;
			}
			var sql = "select name, fullname, mail, phone from ad_info where name in (select user from logons where machine like '%" + queryData.username + "%')";
			connection.query(sql, function(err, result) {
				if (err) {
					console.log("Error query 1: " + err);
					body += '<p>error: ' + err + '<p>';
					makeuserresponse(response, body);
					connection.end(function(err) {});
				} else {
					if (result.length === 0) {
						body += '<p class="redp">ничего не найдено' + '</p>';
						makeuserresponse(response, body);
						connection.end(function(err) {});
						return;
					}
					var subq = result.length;
					var q_body = result.slice();
					for (var i = 0; i < result.length; i++) {
						var sql2 = "select " + i + " as idx, user, machine, ip, DATE_FORMAT(time,'%d.%m.%y в %k:%i')as s_time from logons where (user = '" + result[i].name + "')order by time desc";
						connection.query(sql2, function(err, result) {
							if (err) {
								console.log("Error query 2: " + err);
								body += '<p>error: ' + err + '</p>';
								makeuserresponse(response, body);
								connection.end(function(err) {});
							} else {
								if (result.length !== 0) {
									body += '<div class="user_details"><h4><a title="Посмотреть подробную информацию" href="/userdetails?username=' + q_body[result[0].idx].name + '"">' + q_body[result[0].idx].name;
									body += ', ' + q_body[result[0].idx].fullname;
									body += ', ' + q_body[result[0].idx].mail;
									body += ', ' + q_body[result[0].idx].phone + '</h4></a>';
									body += '<ol>';
									for (var j = 0; j < result.length; j++) {
										body += '<li>' + result[j].machine + "";
										body += ' IP="' + result[j].ip + '", ';
										body += ' заходил(а) ' + result[j].s_time + '</li>';
									}
									body += '</ol></div>';
								} else {

								}
								subq = subq - 1;
								if (subq === 0) {
									connection.end(function(err) {});
									makeuserresponse(response, body);
								}
							} 
						}); 
					} 
				}; 
			}); 
		}); 

	} else { 
		makeuserresponse(response, body);
	}
}
exports.insert = insert;
exports.user = user;
exports.upload = upload;
exports.userdetails = userdetails;
exports.usersearch = usersearch;
exports.pcsearch = pcsearch;
exports.main = main;
exports.img = img;
exports.css = css;
exports.js = js;
exports.font = font;
exports.favicon = favicon;