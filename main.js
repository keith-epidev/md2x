//load node libs
var fs = require('fs');
//load our libs in
eval(fs.readFileSync('utils/loader.js')+'');
load_folder('utils');
load_folder('templates');



//globals
var defines = {};



section = [
function(label){return ""},
function(label){return "\\chapter{"+label+"}\n\\label{"+label+"}\n\\lhead{ \\emph{"+label+"}}";},
function(label){return "\\section{"+label+"}"},
function(label){return "\\subsection{"+label+"}"}
];



main();
function main(){
	var file;

	if(process.argv.length > 2)
	file = process.argv[2];
	else
	file = 'index.md';

	var doc = parse_file(file);
	var cls = parse_file('templates/theme.cls');
//	console.log(cls);
	fs.writeFileSync('build/Thesis.tex',doc);
	fs.writeFileSync('build/Thesis.cls',cls);
	
}





function parse_file(file,level){
	if(typeof level == 'undefined')
		level = 0;

	if(level == 0){
		console.log(file);
	}else{
	var str = "";
	for(var i = 0; i < level; i++)
	str += "\t";
	str += "-"+file;
	console.log(str);
	}


//message("level:"+level);

	var data;
	try{
		if(fs.lstatSync(file).isDirectory())
			file += "/index.md";
		data = fs.readFileSync(file).toString();
	}catch(E){
		data = "File "+file+" not found.";
		error(data);
		data = data.replace("_","\\_");
		data = "{\\color{red}"+data+"}\n";
		return data+'\n';
}

	var dir = file.split("/");
	dir.pop();
	dir = dir.join('/');
	if(dir == '')
		dir = '.';


	//rip comments out
	var r = new RegExp("http://",'gm');
	data = data.replace(r,"http__");
	var r = new RegExp("\/\/(.+)",'gm');
	data = data.replace(r,"");
	var r = new RegExp("http__",'gm');
	data = data.replace(r,"http://");

	//rip defines out
	while(true){
		var patt = /#define ([\w\-]+) (.+)\n/m;
		var m = patt.exec(data);
		if(m == null) break;
		defines[m[1]] = m[2];
		defines[m[1].toUpperCase()] = m[2].toUpperCase();
		data =	data.replace(patt,"",1);
	}


        //loop through defines and replace
        for(define in defines){
        var r = new RegExp("#"+define+"\\b",'g');
        data = data.replace(r,defines[define]);
        }


	//find templates
	while(true){
		var patt = /\#\((.+)\)\n/m;
		var m = patt.exec(data);
		if(m == null) break;
		data =	data.replace(patt,load_templates(m[1]),1);
	}
		
	//find templates with data
	while(true){
		var patt = /\#\((.+)\){\n(.+)}/mg;
		var m = patt.exec(data);
		if(m == null) break;

		console.log(m[1]);
//		data =	data.replace(patt,load_templates(m[1],m[2]),1);
	}

	//find headers
	data =	data.replace(/^(.+)\n(=+)/g,section[level]("$1"));

	//find includes withicomments
	while(true){
		var patt = /\!\[(.+)\]\((.+)\)\n/m;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,picture(m[1],m[2]),1);
		///console.log(data);
	}

	//find includes without comments
	while(true){
		var patt = /\!\[(.+)\]\n/m;
		var m = patt.exec(data);
		if(m == null) break;
		data =	data.replace(patt,parse_file(dir+'/'+m[1],level+1),1);
	}


	

	return data;
}



function picture(file,comment){
	console.log(file);
return "\\begin{figure}[H]\n\\centering%\n\\includegraphics{"+file+"}\n\\caption{"+comment+"}\n\\label{fig:FigureExample}\n\\end{figure}";

}

