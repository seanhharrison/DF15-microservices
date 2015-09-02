public with sharing class P4_MessageHandlerContact implements MessageHandlerInf {

	public static Contact handleMessage(Map<String,String> params) {
		List<Contact> cList = [SELECT Name, Title, Image__c, Description, Alignment__c FROM Contact 
								WHERE Alignment__c = :params.get('alignment') 
								LIMIT 200];
		Double factor = Math.random();
		Integer index = Math.round((cList.size()-1)*factor);
		return cList[index];
	}
}