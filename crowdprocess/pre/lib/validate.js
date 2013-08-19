var fs = require('fs');
var async = require('async');
var revalidator = require('revalidator');
var es = require('event-stream');
var JSONStream = require('JSONStream');


//stdin: data.json
//stdout: valid data.json	


module.exports = function(schema){	
		
	var s = es.pipeline(
		JSONStream.parse(),
		es.map(function(obj,callback){	

		 	var validate = function(unit,calback){
		 		var result = revalidator.validate(unit,schema);
		 
		 		if(result.valid){
		 			calback(null);	
		 		}
		 		else calback(new Error(JSON.stringify(result.errors)));
		    	
			}

			async.each(obj,validate,function(err){
					if(err) callback(err,null);
					else callback(null,obj);	
			});
		}),
	    JSONStream.stringify(false)
	);

	return s;

}
