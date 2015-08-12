@RestResource(urlMapping='/P1/*')
global class P1_Listener {

	@HttpGet
	global static P1Response doGet() {
		RestRequest req = RestContext.request;
		P1Response result = new P1Response(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1), getRandomContact());
		return result;
	}

	@HttpPost
	global static P1Response doPost() {
		RestRequest req = RestContext.request;
		P1Response result = new P1Response(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1), getRandomContact());

		return result;
	}

	global static Contact getRandomContact() {
		Contact c = [SELECT Name, Title, Description FROM Contact LIMIT 1];
		return c;
	}

	global with sharing class P1Response {
		public String thx = 'Thanks for sending me a request';
		public String input = 'Your input was: ';
		public Contact randomContact {get; set;}

		public P1Response(String inp, Contact con) {
			input += inp;
			randomContact = con;
		}
	}
}