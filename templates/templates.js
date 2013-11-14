templates={};






load_templates = function(file){
	
        var data;
        try{
                data = fs.readFileSync('templates/'+file).toString();
        }catch(E){
                data = "File '"+file+"' not found.";
                error(data);
                return data+'\n';
	}



	//loop through defines and replace

	for(define in defines){
	var r = new RegExp("#"+define+"\\b",'g');
	data = data.replace(r,defines[define]);

	}

	
	return data;


}

load_templates_data = function(file,body){
	
        var data;
        try{
                data = fs.readFileSync('templates/'+file).toString();
        }catch(E){
                data = "File '"+file+"' not found.";
                error(data);
                return data+'\n';
	}

	//get rid of data define first
	var r = new RegExp("#data",'g');
	console.log(r);
	console.log(body);
	data = data.replace(r,body);

	//loop through defines and replace

	for(define in defines){
	var r = new RegExp("#"+define+"\\b",'g'); //this boundary stuff may get annoying
	data = data.replace(r,defines[define]);

	}

	
	return data;


}
