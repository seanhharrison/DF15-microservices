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

	/**
	 * Private method whereby the class posts a message to the queue and then gathers the related
	 * response synchronously from the same queue. The response is used to query a Contact record.
	 **/
	private Contact requestContact() {
		Message_Queue__c message = new Message_Queue__c(Queue_Name__c = 'pattern4');
		Datetime dt = Datetime.now();
		String responseId = String.valueOf(dt.getTime());
		message.Message__c = '{ "responseId" : "'+responseId+'", "alignment" : "'+alignment+'"}';
		insert message;

		Message_Queue__c reply = [
			SELECT Name, Message__c 
			FROM Message_Queue__c
			WHERE Queue_Name__c = :responseId
			LIMIT 1];

		reply.Read_Time__c = Datetime.now();
		update reply;

		Contact c = [
			SELECT Name, Title, Image__c, Description, Alignment__c 
			FROM Contact 
			WHERE Id = :reply.Message__c];
		return c;
	}

	public static void clearQueue() {
		List<Message_Queue__c> messages = [SELECT Id FROM Message_Queue__c];
		delete messages;
	}
}