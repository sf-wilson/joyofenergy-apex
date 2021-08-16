public without sharing class refreshContact {
	@AuraEnabled(cacheable=true)
    public static Contact getContactDetails(Id conid) {
        return [SELECT FirstName, LastName FROM Contact WHERE Id = :conid];
    }
}