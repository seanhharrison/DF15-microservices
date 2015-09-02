/**
 *

 { queue: 'pattern2', message:{device: 'my deviceType', alignment: 'good/evil'} }

from that you should then have your endpoint go:
pattern2 is the queue, what do we have as the class to instantiate for this (read from a custom setting)
Instantiate that class (implements the interface) and we call the handleMessage method
Based upon the device and the alignment return a contact
Device's would be:
Android
iOS
Opera
Windows
Desktop
I was thinking the alignment thing would be a cool twist so the contact returned would be either a good guy or a bad guy depending on the button they press. Thought you might enjoy creating some interesting character's as well (as a note remember to do both male and female mix).

 *
 **/
@RestResource(urlMapping='/P2/*')
global class P2_Listener {

	@HttpPost
	global static P2Response doPost() {

		RestRequest req = RestContext.request;
		String reqBody = req.requestBody.toString();
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

		Message_Handlers__c handler = Message_Handlers__c.getInstance(params.get('queue'));

		if (handler==null) {
			P2Response result = new P2Response(reqBody, 'no handler class defined');
			return result;
		} else {
			String className = handler.Class_Name__c;

			Type t = Type.forName(className);
			MessageHandlerInf newObj = (MessageHandlerInf) t.newInstance();

			P2Response result = new P2Response(reqBody, newObj.handleMessage(params));
			return result;
		}
	}

	global class P2Response {
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