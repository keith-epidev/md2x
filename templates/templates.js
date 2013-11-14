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
