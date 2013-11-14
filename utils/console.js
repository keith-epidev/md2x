var colors = require('colors');


message = function(message){

	console.log(("[+] "+message+"").green);
}

error = function(message){
	console.log(("[!] "+message+"").red);
}
