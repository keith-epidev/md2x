//depends on
eval(fs.readFileSync('utils/console.js')+''); 

function load_folder(folder){
	var files = fs.readdirSync(folder);
	for(var i = 0; i < files.length; i++){
		var f = files[i];
		if(f.substring(f.length-3,f.length) == '.js')
		load(folder+'/'+f);
	}

}


function load(file){
	try{
//	with (global) {
		var t = eval(fs.readFileSync(file)+'');
//		console.log(t);
//		console.log(t);
//	}
	}catch(E){		
		error("Could not open '"+file+"' : "+E);

	}
}

