function Run(data){

{{{COMPRESS}}}

Module = {};
Module['preRun'] = [];
Module['return'] = {};
Module['return']['output'] = {};
Module['return']['output']['files'] = {};
Module['return']['output']['stdout'] = '';
Module['return']['output']['stderr'] = '';

Module['compress'] = module.exports.compress;
Module['decompress'] = module.exports.decompress;


Module['dirname'] = function dirname(path){

  return path.substring(0,path.lastIndexOf('/')+1);
}

Module['basename'] = function basename(path){

  return path.substring(path.lastIndexOf('/')+1);
}


Module['preRun'].push(function () {

if((data.input) && (data.input.files)){ 

	data.input.files.forEach(function(file) {
 
		var dirname = Module['dirname'](file.name);
		var basename = Module['basename'](file.name);
		var content = ((file.decompress) || (file.compress)) ? Module['decompress'](file.content) : file.content;
		
		Module['FS_createDataFile'](dirname,basename,content,true,true); 
	}); 

}
	{{{FILES_IN}}}

	Module['print'] = function(text){
		Module['return']['output']['stdout'] += text + '\n';
	};

	Module['printErr'] = function(text){
		Module['return']['output']['stderr'] += text + '\n';
	};
});

{{{GENERATED_CODE}}}

Module['arguments'] = [];

if((data.input) && (data.input.argv)){
	//nao gosto do nome argv!!	
	var argv = data.input.argv;
	argv.forEach(function(arg){
		Module['arguments'][arg.pos] = arg.arg;
	});
}

{{{ARGS}}}

Module.callMain(Module['arguments']);

{{{FILES_OUT}}}

if((data.output) && (data.output.files)){
	var i = 0;
	data.output.files.forEach(function(file) {
    //permite apenas ir buscar a root
		var dirname = Module['dirname'](file.name);
		//Rever basename e content
		var basename = Module['basename'](file.name);
		var content = intArrayToString(FS.root.contents[basename].contents);
		content = ((file.compress) || (file.decompress)) ? Module['compress'](content) : content;

		Module['return']['output']['files'][i] = { name: dirname+'/'+basename, content : content };
    
    i++;

	}); 

}

return Module['return'];
}
