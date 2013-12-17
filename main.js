//load node libs
var fs = require('fs');
var execSync = require('exec-sync');
//load our libs in
eval(fs.readFileSync('utils/loader.js')+'');
load_folder('utils');
load_folder('templates');



//globals
var root;
var defines = {};



section = [
function(label){return ""},
function(label){return "\\chapter{"+label+"}\n\\label{"+label+"}\n\\lhead{ \\emph{"+label+"}}";},
function(label){return "\\section{"+label+"}"},
function(label){return "\\subsection{"+label+"}"},
function(label){return "\\subsubsection{"+label+"}"}
];


var symbols = {
"°":"\\textdegree ",
"%":"\\%",
"\\$":"\\textdollar "};

main();
function main(){

	if(process.argv.length > 2)
	file = process.argv[2];
	else
	file = 'index.md';

	root = file.substr(0,file.lastIndexOf('/'));
	var file = file.substr(file.lastIndexOf("/")+1,file.length-1);

	if(file == "")
		file = "index.md";

	console.log("root: "+root);
	console.log("file: "+file);

	var doc = parse_file(file);
	var cls = load_templates('theme.cls');
//	console.log(cls);
	fs.writeFileSync('build/Thesis.tex',doc);
	fs.writeFileSync('build/Thesis.cls',cls);

	//check if Bibliography.bib exists and copy if so
	try{
		var bib = fs.readFileSync(root+"/Bibliography.bib").toString();
		fs.writeFileSync('build/Bibliography.bib',bib);
	}catch(E){console.log(E);}


	
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
		if(fs.lstatSync(root+"/"+file).isDirectory())
			file += "/index.md";
		data = fs.readFileSync(root+"/"+file).toString();
	}catch(E){
		data = "File "+root+"/"+file+" not found.";
		error(data);
		data = data.replace("_","\\_");
		data = "{\\color{red}"+data+"}\n";
		return data+'\n';
	}

	
	var dir = file.split("/");
	dir.pop();
	dir = dir.join('/');
	if(dir == '')
		dir = '';
	else
	dir += "/"

//	console.log("dir: "+dir);
//	console.log("file: "+file);
	

	var type = file.substr(file.lastIndexOf('.')+1,file.length-1);
//	console.log('type: '+type)

	//escape #
	var r = new RegExp("\\\\#",'gm');
	data = data.replace(r,"_HASH_");

	//rip comments out
	var r = new RegExp("http://",'gm');
	data = data.replace(r,"http__");
	var r = new RegExp("https://",'gm');
	data = data.replace(r,"https__");
	var r = new RegExp("\/\/(.+)",'gm');
	data = data.replace(r,"");
	var r = new RegExp("http__",'gm');
	data = data.replace(r,"http://");
	var r = new RegExp("https__",'gm');
	data = data.replace(r,"https://");

	//rip defines out
	while(true){
		var patt = /^#define ([\w\-]+) (.+)\n/m;
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

	//markdown only parse
	if(type == 'md'){
	
	//find symbols
	for(symbol in symbols){
        	var r = new RegExp(symbol,'g');
		data =	data.replace(r,symbols[symbol]);
	}




	//find headers
	data =	data.replace(/^(.+)\n(=+)$/mg,section[level]("$1"));
	//find sub headers
	data =	data.replace(/^(.+)\n(-+)$/mg,section[level+1]("$1"));

	//find unorded list
	while(true){
	var patt = /(^\t*-.+\n)+/m;
	var m = patt.exec(data);
		if(m == null) break;
//		console.log(m);
		data = data.replace(patt,list(m[0]),1);
	}
	//find enum list
	while(true){
	var patt = /(^\t*\*.+\n)+/m;
	var m = patt.exec(data);
		if(m == null) break;
//		console.log(m);
		data = data.replace(patt,enum_list(m[0]),1);
	}

	//find tables
	while(true){
		var patt = /((^\|.+\n)+)(.*)/m;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,table(m[1],m[3]),1);
		//console.log(data);
	}

	//find code
	while(true){
		var patt = /``\n((.*\n)*?)``/;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,code(m[1]),1);
		///console.log(data);
	}




	//find includes with comments
	while(true){
		var patt = /\!\[(.+)\]\((.+)\)\n/m;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,picture(m[2],m[1],dir),1);
		///console.log(data);
	}

	//find includes with comments and attribute
	while(true){
		var patt = /\!\[(.+)\]\((.+)\)\{(.+)\}\n/m;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,picture(m[2],m[1],dir,m[3]),1);
		///console.log(data);
	}

	//find links
	while(true){
		var patt = /\[(.+?)\]\((.+?)\)/;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,href(m[2],m[1]),1);
		///console.log(data);
	}

	//find cites
	while(true){
		var patt = /cite\[(.+?)\]/;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,cite(m[1]),1);
		///console.log(data);
	}
	//find ref
	while(true){
		var patt = /ref\[(.+?)\]/;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,ref(m[1]),1);
		///console.log(data);
	}

	//find italics
	while(true){
		var patt = /~((\w+\s*){1,4})~/m;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,italics(m[1]),1);
		///console.log(data);
	}


	//find italics
	while(true){
		var patt = /\*((\w+\s*){1,4})\*/m;
		var m = patt.exec(data);
		if(m == null) break;
		data = data.replace(patt,bold(m[1]),1);
		///console.log(data);
	}

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
		var patt = /\#\((.+)\){\n((.*\n)*)}/;
		var m = patt.exec(data);
		if(m == null) break;

		data =	data.replace(patt,load_templates_data(m[1],m[2]),1);
	}

	//find math
        	var r = new RegExp("\#",'g');
		data =	data.replace(r,"$$");

	//unescape hashes
	var r = new RegExp("_HASH_",'gm');
	data = data.replace(r,"#");

	//find includes without comments
	while(true){
		var patt = /\!\[(.+)\]\n/m;
		var m = patt.exec(data);
		if(m == null) break;
		var import_file = parse_file(dir+m[1],level+1);
		import_file  =	import_file.replace(new RegExp("\\$","g"),"$$$$");
		data =	data.replace(patt,import_file,1);
		//console.log(import_file);
	}

	
	return data;
}


function code(body){
	return "\\begin{lstlisting}\n"+body+"\n\\end{lstlisting}";
}

function ref(id){
	return "\\ref{fig:"+id+"}";
}

function cite(id){
	return "\\cite{"+id+"}";
}

function href(link,label){
	return "\\href{"+link+"}{"+label+"}";
}

function italics(text){
	return "\\textit{"+text+"}";
}

function bold(text){
	return "\\textbf{"+text+"}";
}


function picture(file,comment,dir,opt){
/*
	console.log("=== picture =====");
	console.log("file: "+file);
	console.log("dir: "+dir);
	console.log("Comment:"+comment);
*/
	//make folders if they don't exist
	mkdir('build/fig/'+dir);	
	//lets copy it
	try{execSync('cp '+root+'/'+dir+'/'+file+" build/fig/"+dir);}catch(E){console.log(E)};

	var fileparts = file.split('.');
	var filename = fileparts[0];
	var filetype = fileparts[1];
		
	if(filetype == "svg"){
		try{execSync("rsvg-convert -f pdf  -o build/fig/"+dir+"/"+filename+".pdf   build/fig/"+dir+"/"+file );}catch(E){console.log(E)};
		filetype = "pdf"
	}

	//dir = dir.replace("_","\\_");
	//filename = filename.replace("_","\\_");


	var pic = "";
	if(typeof opt != "undefined" && opt == "page"){
	pic +="\\begin{figure}[htbp]\n";
	pic += "\\centering\n";
        pic += "\\resizebox{\\textwidth}{!}{\\includegraphics{fig/"+dir+filename+"."+filetype+"}}\n";
 	pic += "\\end{figure}\n";
	pic += "\\clearpage\n";

	}else{
	pic += "\\begin{figure}[H]\n";
	pic += "\\centering%\n";
	if(typeof opt == "undefined")
	pic += "\\includegraphics{fig/"+dir+filename+"."+filetype+"}\n";
	else
	pic += "\\includegraphics["+opt+"]{fig/"+dir+filename+"."+filetype+"}\n";

	if(comment !=  " ")
	pic += "\\caption{"+comment+"}\n";
	pic += "\\label{fig:"+file+"}\n";
	pic += "\\end{figure}";
	}


	return pic;
}

function enum_list(data,level){
//split up into lines
data = data.split("\n");
if(typeof level == "undefined")
level = 0;

var collected = "\\begin{enumerate}\n";

	while(true){
		var line = data.shift();
		var patt = new RegExp("\t");
		var nl = line.match(patt);
		if(nl == null) nl = []
		
		if(nl.length > level){
			collected += "\\begin{itemize}\n";
		}else
		if(nl.length < level){
			collected += "\\end{itemize}\n";

		}
		level = nl.length;	
		

		var patt = new RegExp("^\t*\\\*(.+)","m");
		var m = patt.exec(line);

			if(m == null){
			break;
			}

		collected += "\\item "+m[1]+"\n";

			if(data.length == 0)
				break;
			
		//current is the same level
		


		
	}

collected += "\\end{enumerate}\n";

return collected;



}


function table(data,label){
data = data.split("\n");
for(var i = 0; i < data.length; i++){
	data[i] = data[i].substring(1,data[i].length-1);
	data[i] = data[i].split("|");
	}

console.log(data);

var out = "";
out += "\\begin{table}[!h]\n";
out += "\\centering\n";
out += "\\begin{tabulary}{\\textwidth}{";
for(var i = 0; i < data[0].length; i++)
	out += "L";

out +="}\n";
out+="\\hline\\hline\n";
//table has started
for(var i = 0; i < data.length; i++){
	if(data[i][0].match(new RegExp("(^─+)")) != null )   //match -------
		out+="\\hline\n";
	else{
	//loop through elements
	out += data[i][0];
	for(var j = 1; j < data[i].length; j++)
		out += " & "+data[i][j];
	out += "\\\\\n";
	}
}
out += "\\end{tabulary}\n";
out += "\\caption{"+label+"}\n";
out += "\\label{1}\n"
out += "\\end{table}\n";
out = out.replace(new RegExp("\\$","g"),"$$");
console.log("out->");
console.log(out);


return out;
}
/*
\begin{table}[!h]
\centering
\begin{tabulary}{\textwidth}{LLLL}
\hline\hline
Risk (event) & Likelihood (H/M/L) & Impact (H/M/L) & Action \\
\hline\hline
Development starts late & M & L & 2 \\
Schematics Incorrect & M & L & 1 \\
PCB Incorrect & M & L & 1 \\
Unobtainable parts & H & L & 3 \\
Components break & H & M & 3 \\
Underestimate Project time frame & M & H & 2 \\
Underestimate Complexity & H & H & 4 \\
Implementation does not function & M & M & 1 \\
Incomplete project threat & L & H & 4 \\
Code is lost / corrupted & L & L & 5 \\
\hline

\end{tabulary}
\caption{List of possible risks} % title of Table
\label{1}
\end{table}
*/



function list(data,level){
//split up into lines
data = data.split("\n");
if(typeof level == "undefined")
level = 0;

var collected = "\\begin{itemize}\n";

	while(true){
		var line = data.shift();
		var patt = new RegExp("\t");
		var nl = line.match(patt);
		if(nl == null) nl = []
		
		if(nl.length > level){
			collected += "\\begin{itemize}\n";
		}else
		if(nl.length < level){
			collected += "\\end{itemize}\n";

		}
		level = nl.length;	
		

		var patt = new RegExp("^\t*-(.+)","m");
		var m = patt.exec(line);

			if(m == null){
			break;
			}

		collected += "\\item "+m[1]+"\n";

			if(data.length == 0)
				break;
			
		//current is the same level
		


		
	}

collected += "\\end{itemize}\n";

return collected;



}





