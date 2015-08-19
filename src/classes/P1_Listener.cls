@RestResource(urlMapping='/P1/*')
global class P1_Listener {

	@HttpGet
	global static P1Response doGet() {
		RestRequest req = RestContext.request;
		return respond(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1), req.requestBody.toString());
	}

	@HttpPost
	global static P1Response doPost() {
		RestRequest req = RestContext.request;
		return respond(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1), req.requestBody.toString());
	}

	global static P1Response respond(String queue, String reqBody) {
		System.debug('PAUL:' + reqBody);
		JSONParser parser = JSON.createParser(reqBody);
		Map<String,String> params = new Map<String,String>();
		while (parser.nextToken() != null) {
		if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String key = parser.getText();
				parser.nextValue();
				params.put(key,parser.getText());
			}
		}
		P1Response result = new P1Response(queue+' = '+reqBody, getRandomContact(params.get('device')));
		return result;
	}

	global static Contact getRandomContact(String device) {
		Contact c = [SELECT Name, Title, Image__c, Description, Alignment__c FROM Contact WHERE Device__c = :device LIMIT 1];
		return c;
	}

	global with sharing class P1Response {
		public String input = 'Your input was: ';
		public Contact randomContact {get; set;}

		public P1Response(String inp, Contact con) {
			input += inp;
			randomContact = con;
		}
	}
}