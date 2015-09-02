/**
 * This class is called from a trigger on Message_Queue__c and serves as 
 * the broker for new messages added to that custom object. 
 *
 * This variation of the microservice pattern functions synchronously 
 *
 * @author Sean Harrison
 * @see Message_Queue__c
 *
 **/
 public with sharing class P4_Broker {

	/**
	 * This method will retrieve all open messages of the 'pattern4' type and 
	 * pass to a downstream service for processing. The service is determined
	 * dynamically based on custom settings. After passing, this class will post 
	 * any responses back to the queue and return additional information for 
	 * logging upstream
	 *
	 * NOT BULK-SAFE !!!
	 *
	 * @return List<P4Response>  A List of P4Response objects with debugging information
	 *
	 **/
	public static List<P4Response> consumeMessages() {

		List<Message_Queue__c> messagesToProcess = [
			SELECT Id, Name, Queue_Name__c, Message__c 
			FROM Message_Queue__c
			WHERE Queue_Name__c LIKE 'pattern4%' AND Read_Time__c = NULL];

		p('messagesToProcess: '+messagesToProcess);
		List<Message_Queue__c> incomingMessages = new List<Message_Queue__c>();
		List<Message_Queue__c> responseMessages = new List<Message_Queue__c>();
		List<P4Response> feedback = new List<P4Response>();

		for (Message_Queue__c message : messagesToProcess) {
			p('message:' + message.Message__c);

			message.Read_Time__c = Datetime.now();
			incomingMessages.add(message);
			JSONParser parser = JSON.createParser(message.Message__c);
			Map<String,String> params = new Map<String,String>();
			while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String key = parser.getText();
					parser.nextValue();
					params.put(key,parser.getText());
				}
			}

			Map<String, Message_Handlers__c> handlers = Message_Handlers__c.getAll();
			Message_Handlers__c handler = handlers.get(message.Queue_Name__c);
			p('handler:' + handler.Class_Name__c);

			if (handler==null) {
				P4Response result = new P4Response(message.Message__c, 'no handler class defined');
				feedback.add(result);
				responseMessages.add(new Message_Queue__c(Queue_Name__c = params.get('responseId')));
			} else {
				String className = handler.Class_Name__c;

				Type t = Type.forName(className);
				MessageHandlerInf newObj = (MessageHandlerInf) t.newInstance();

				P4Response result = new P4Response(message.Message__c, newObj.handleMessage(params));
				feedback.add(result);
				Message_Queue__c responseMessage = new Message_Queue__c();
				responseMessage.Queue_Name__c = params.get('responseId');
				responseMessage.Message__c = result.randomObj.Id;
				responseMessages.add(responseMessage);
			}		
		}
		update incomingMessages;
		insert responseMessages;
		return feedback;
	}

	/**
	 * Inner class to hold debugging information for return to calling services
	 **/
	public class P4Response {
		public String thx = 'Thanks for sending me a request';
		public String input = 'Your input was: ';
		public Sobject randomObj {get; set;}

		public P4Response(String inp, Object obj) {
			input += inp;
			randomObj = (Sobject) obj;
		}
		public P4Response(String inp, String err) {
			thx = err;
			input += inp;
		}
	}

// DELETE ME
	static void p(String m) {
		System.debug('\n\n\nYYZ - '+m+'\n\n\n\n');
	}
}