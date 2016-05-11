var mysql	= require('mysql');
var fs = require('fs');
var exec = require('child_process').exec;
var mybase = require('./mybase.js');  
exec('adq.vbs', function (error, stdout, stderr) {
    if (error !== null) {
      console.log('exec error: ' + error);
      return;
    }

    var array = fs.readFileSync('d:\\node\\adq.txt').toString('utf16le').split("\r\n");
    var strsAMAccountName;
    var strdisplayname;
    var strmail;
    var strtelephoneNumber;
    var strphysicalDeliveryOfficeName;
    var index;

	var connection = mysql.createConnection(mybase.connection_data);

    connection.connect(function(err) {
	    if (err) {
		  	console.log("error connecting: " + err);
		    return;
		}
	    
	    for(i in array) {
		    str = array[i].toString().trim();
	
		    index = str.indexOf(";");
		    strsAMAccountName = str.substr(0, index);
		    str = str.substr(index +1);
	
		    index = str.indexOf(";");
		    strdisplayname = str.substr(0, index);
		    str = str.substr(index +1);

		    index = str.indexOf(";");
		    strmail = str.substr(0, index);
		    str = str.substr(index +1);

		    index = str.indexOf(";");
		    strtelephoneNumber = str.substr(0, index);
		    str = str.substr(index +1);

		    index = str.indexOf(";");
		    strphysicalDeliveryOfficeName = str.substr(0, index);

			
		
		    if (strsAMAccountName != "") {
		
			    if (!strdisplayname) {
			        strdisplayname = strsAMAccountName;
		        }
			    if (!strmail) {
			        strmail = "-";
		        }
			    if (!strtelephoneNumber) {
			        strtelephoneNumber = "-";
		        }
			    if (!strphysicalDeliveryOfficeName) {
			        strphysicalDeliveryOfficeName = "-";
		        }
		        
		
			    
			    var sql =	"INSERT INTO ad_info (name, fullname, mail, phone, office) values ("+
				    connection.escape(strsAMAccountName)+","+
				    connection.escape(strdisplayname)+","+
				    connection.escape(strmail)+","+
				    connection.escape(strtelephoneNumber)+","+
				    connection.escape(strphysicalDeliveryOfficeName)+
				    ") ON DUPLICATE KEY UPDATE "+
					    "fullname=VALUES(fullname), "+
					    "mail=VALUES(mail), "+
					    "phone=VALUES(phone),"+
					    "office=VALUES(office)";
	
			    connection.query(sql, function(err, result) {
				    if (err) {
					    console.log("Error = "+err);
				    } else {
					    //console.log("result = "+result.insertId);
				    };
			    });
		    }
	    }
        connection.end(function(err) {});
        clearlogons();
    });
});
function clearlogons(){
    var connection = mysql.createConnection(mybase.connection_data);
    connection.connect(function(err) {
	    if (err) {
		  	console.log("error connecting: " + err);
		    return;
		}
	    var sql = "select name from ad_info";
	    connection.query(sql, function(err, result) {
		    if (err) {
				connection.end(function(err) {});
		    } else {
		        var usr_count = result.length;
    			for(var i=0; i<result.length; i++) {
                    sql = "delete from logons where (user = '"+result[i].name+"') and idlogons not in (select idlogons from (select idlogons from logons where user = '"+result[i].name+"' order by time desc limit 5) tmp)";
    			    connection.query(sql, function(err, result) {
	    			    if (err) {
		    			    console.log("Error = "+err);
			    	    } else {
				        };
			    	    usr_count = usr_count - 1;
			    	    if (usr_count == 0) {
			    	        connection.end();
			    	    }
			        });

    			}
	        }

	    });
	});
}