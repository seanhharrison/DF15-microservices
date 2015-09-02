/**
 * A trigger on the message queue custom object which passes message to 
 * the broker class, if appropriate
 *
 * This variation of the microservice pattern functions synchronously 
 *
 * @author Sean Harrison
 * @see P4_Broker.cls
 **/
trigger Message_QueueTrigger on Message_Queue__c (after insert) {

	List<Message_Queue__c> messagesToProcess = new List<Message_Queue__c>();
	for (Message_Queue__c message : Trigger.new) {
		if (message.Queue_Name__c.startsWith('pattern4')) messagesToProcess.add(message); // needed to prevent recursion
	}
	if (!messagesToProcess.isEmpty()) System.debug(P4_Broker.consumeMessages());
}