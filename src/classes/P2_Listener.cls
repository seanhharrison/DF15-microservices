@RestResource(urlMapping='/P2/*')
global class P2_Listener {

	@HttpGet
	global static P2Response doGet() {

		RestRequest req = RestContext.request;
		String message = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

		Message_Handlers__c handler = Message_Handlers__c.getInstance(message);

		if (handler==null) {
			P2Response result = new P2Response(message, 'no handler class defined');
			return result;
		} else {
			String className = handler.Class_Name__c;

			Type t = Type.forName(className);
			GetRandomObj newObj = (GetRandomObj) t.newInstance();

			P2Response result = new P2Response(message, newObj.get());
			return result;
		}
	}

	@HttpPost
	global static P2Response doPost() {

		RestRequest req = RestContext.request;
		String message = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

		Message_Handlers__c handler = Message_Handlers__c.getInstance(message);

		if (handler==null) {
			P2Response result = new P2Response(message, 'no handler class defined');
			return result;
		} else {
			String className = handler.Class_Name__c;

			Type t = Type.forName(className);
			GetRandomObj newObj = (GetRandomObj) t.newInstance();

			P2Response result = new P2Response(message, newObj.get());
			return result;
		}
	}

	global with sharing class P2Response {
		public String thx = 'Thanks for sending me a request';
		public String input = 'Your input was: ';
		public Sobject randomObj {get; set;}

		public P2Response(String inp, Object obj) {
			input += inp;
			randomObj = (Sobject) obj;
		}
		public P2Response(String inp, String err) {
			thx = err;
			input += inp;
		}
	}
}