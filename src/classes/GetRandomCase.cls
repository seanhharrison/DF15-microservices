global class GetRandomCase implements GetRandomObj {
	global Case get() {

		List<Case> cList = [SELECT CaseNumber, Contact.Name, Subject FROM Case LIMIT 200];
		if (!cList.isEmpty()) {
			Double factor = Math.random();
			Integer index = Math.round((cList.size()-1)*factor);
			return cList[index];
		} else {
			return new Case();
		}
	}
}