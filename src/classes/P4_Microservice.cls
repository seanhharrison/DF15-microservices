/**
 * A simple class functioning as a microservice which will post messages to a message queue
 * custom object and subsequently receive a Contact id from the same queue.
 *
 * This variation of the microservice pattern functions synchronously 
 *
 * @author Sean Harrison
 * @see Message_Queue__c
 *
 **/
public with sharing class P4_Microservice {

	public String  alignment { get; set; }
	public Contact person    { get; private set;}


	/** 
	 * Constructor which takes a string "alignment" which is one of: [ good | evil | indefinite ]
	 * then sets the object's properties
	 **/
	public P4_Microservice(String a) {
		alignment = a;
		person = requestContact();
	}

	public P4_Microservice() {
		alignment = 'Good';
	}

	/**
	 * Private method whereby the class posts a message to the queue and then gathers the related
	 * response synchronously from the same queue. The response is used to query a Contact record.
	 **/
	public Contact requestContact() {
		Message_Queue__c message = new Message_Queue__c(Queue_Name__c = 'pattern4');
		message.Message__c = '{ "alignment" : "'+alignment+'" }';
		Database.SaveResult sr = Database.insert(message, false);

		Message_Queue__c reply = [
			SELECT Reply__c 
			FROM Message_Queue__c
			WHERE Id = :sr.Id];
		String cId;
		JSONParser parser = JSON.createParser(reply.Reply__c);
		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String key = parser.getText();
				if (key.equals('Id')) {
					parser.nextValue();
					cId = parser.getText();
				} 
			}
		}

		Contact c = [
			SELECT Name, Title, Image__c, Description, Alignment__c 
			FROM Contact 
			WHERE Id = :cId];
		return c;
	}

	public static void clearQueue() {
		List<Message_Queue__c> messages = [SELECT Id FROM Message_Queue__c];
		delete messages;
	}

	public PageReference getContact() {
		person = requestContact();
		return null;
	}
	public List<SelectOption> getItems() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('Good','Good'));
		options.add(new SelectOption('Evil','Evil'));
		options.add(new SelectOption('Indefinite','Indefinite'));
        return options;
    }
}