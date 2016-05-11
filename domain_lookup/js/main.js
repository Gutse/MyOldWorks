var current_bar = "";

function sidebar_click(event) {
	/*mainbar = */
	if (current_bar !== event.target.id) {
		if (current_bar !== "") {
			document.getElementById(current_bar + "_bar").style.display = "none";
		}
		current_bar = event.target.id;
		if (current_bar !== "") {
			bar = document.getElementById(current_bar + "_bar");
			document.getElementById(current_bar + "_bar").style.display = "block";
		}
	}
}

function search_user(obj) {
	//console.log("asd" + obj);
	var xhr = new XMLHttpRequest(); // (1)
	var outputElem = document.getElementById("user_search_bar_result");
	var usernameElem = document.getElementById("username");

	xhr.open('GET', '/usersearch?username='+usernameElem.value, true); 
//user_search_bar_result
	xhr.onreadystatechange = function() { 
		if (xhr.readyState != 4) return; 
		outputElem.innerHTML = xhr.responseText;
	}

	outputElem.innerHTML = '...';
	xhr.send(null); // (4)	
}

function search_pc(obj) {
	//console.log("asd" + obj);
	var xhr = new XMLHttpRequest(); // (1)
	var outputElem = document.getElementById("pc_search_bar_result");
	var usernameElem = document.getElementById("pcname");

	xhr.open('GET', '/pcsearch?username='+usernameElem.value, true);
//user_search_bar_result
	xhr.onreadystatechange = function() { 
		if (xhr.readyState != 4) return; 
		outputElem.innerHTML = xhr.responseText;
	}

	outputElem.innerHTML = '...';
	xhr.send(null); 
}


function onenterrun(func, event){
	/*console.log( event.charCode);*/
	if (event.charCode === 13) {
		func(this);
	}
}
var list = document.getElementsByClassName("sidebar-item");
for (var i = list.length - 1; i >= 0; i--) {
	list[i].addEventListener("click", sidebar_click);
}