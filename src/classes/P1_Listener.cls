@RestResource(urlMapping='/P1/*')
global class P1_Listener {

	@HttpGet
	global static String doGet() {
		RestRequest req = RestContext.request;
		// RestResponse resp = RestContext.response;
		String result = 
		'{'+
			'"thx": "Thanks for sending me a GET request",'+
			'"input": "Your input was: '+req.requestURI.substring(req.requestURI.lastIndexOf('/'))+'"'+
			'"randomContact" : "'+ getRandomContact() +
		+'}';
		return result;
	}

	@HttpPost
	global static String doPost() {
		RestRequest req = RestContext.request;
		// RestResponse resp = RestContext.response;
		String result = 
		'{'+
			'"thx": "Thanks for sending me a POST request", '+
			'"input": "Your input was: "'+req.requestURI.substring(req.requestURI.lastIndexOf('/'))+
			'\n==========\n'+req.requestBody.toString()+'",'+
			'"randomContact" : "'+ getRandomContact() +
		' }';
		return result;
	}

	global static String getRandomContact() {
		Contact c = [SELECT Name, Title, Description FROM Contact LIMIT 1];
		JSONGenerator jsonGen = JSON.createGenerator(true);
		jsonGen.writeObject(c);
		return jsonGen.getAsString();
	}
}