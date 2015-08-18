global class GetRandomContact implements GetRandomObj {
	global Contact get() {

		List<Contact> cList = [SELECT Name, Title, Description FROM Contact LIMIT 200];
		if (!cList.isEmpty()) {
			Double factor = Math.random();
			Integer index = Math.round((cList.size()-1)*factor);
			return cList[index];
		} else {
			return new Contact();
		}
	}
}