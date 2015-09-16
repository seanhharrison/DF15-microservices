public with sharing class P4_Controller {

	private final sObject mysObject;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public P4_Controller(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
    }

    public String getRecordName() {
        return 'Hello ' + (String)mysObject.get('name') + ' (' + (Id)mysObject.get('Id') + ')';
    }
}