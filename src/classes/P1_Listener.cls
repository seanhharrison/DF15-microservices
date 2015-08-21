@RestResource(urlMapping='/P1/*')
global class P1_Listener {

	@HttpGet
	global static P1Response doGet() {
		RestRequest req = RestContext.request;
		String device = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		
		Contact c = [SELECT Name, Title, Image__c, Description, Alignment__c FROM Contact WHERE Device__c = :device LIMIT 1];
		P1Response result = new P1Response(device, c);
		return result;
	}

	//@HttpPost
	//global static P1Response doPost() {
	//	RestRequest req = RestContext.request;
	//	String queue   = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
	//	String reqBody = req.requestBody.toString();

	//	JSONParser parser = JSON.createParser(reqBody);
	//	String device = '';
	//	while (parser.nextToken() != null) {
	//	if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
	//			String key = parser.getText();
	//			if (parser.getText().equals('device')) {
	//				parser.nextValue();
	//				device = parser.getText();
	//			}
	//		}
	//	}
		
	//	Contact c = [SELECT Name, Title, Image__c, Description, Alignment__c FROM Contact WHERE Device__c = :device LIMIT 1];
	//	P1Response result = new P1Response(queue+' = '+reqBody, c);
	//	return result;
	//}

	global with sharing class P1Response {
		public String input = 'Your input was: ';
		public Contact randomContact {get; set;}

		public P1Response(String inp, Contact con) {
			input += inp;
			randomContact = con;
		}
	}
}