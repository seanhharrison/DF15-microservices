global class MessageHandlerContact implements MessageHandlerInf {
	global Contact handleMessage(Map<String,String> params){

		List<Contact> cList = [SELECT Name, Title, Image__c, Description, Alignment__c FROM Contact 
								WHERE Alignment__c = :params.get('alignment') 
								AND Device__c = :params.get('device') LIMIT 1];

		if (cList.isEmpty()) {
			cList = [SELECT Name, Title, Image__c, Description FROM Contact LIMIT 200];
			Double factor = Math.random();
			Integer index = Math.round((cList.size()-1)*factor);
			return cList[index];
		}

		return cList.get(0); 
	}
}