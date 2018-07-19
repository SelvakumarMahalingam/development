function parseandmatchjson(json1, json2) {

    // private function to traverse json objects recursively
    function traverse(object, callback) {
        for (var key in object) {
            // only return leaf nodes
            if((/boolean|number|string/).test(typeof object[key]))
                callback.apply(this, [object, key, object[key]]);  
            // if not base condition, dig deeper in recursion
            if (object[key] !== null && typeof(object[key]) == "object")
                traverse(object[key], callback);
        }
    }

    // create deep clone copy of json1
   
    var result = JSON.parse(JSON.stringify(json1));

    // create a flattened version of json2 for doing optimized lookups
    var flat_json2 = {};
    traverse(json2, function(object, key,value) {
        flat_json2[key] = value;
    });

    // overwrite values in results, if they exist in json2
    traverse(result, function(object, key, value) {
        if(typeof flat_json2[key] !== "undefined" )
            object[key] =  flat_json2[key];
    });

    return result;    
}