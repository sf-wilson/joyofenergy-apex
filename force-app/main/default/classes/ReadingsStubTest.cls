@isTest
public with sharing class ReadingsStubTest {
    @testSetup
    public static void initData(){
        List<Account> suppliers = new List<Account>();
        suppliers.add(new Account(Name = 'The Green Eco'));
        suppliers.add(new Account(Name = 'Power for Everyone'));
        suppliers.add(new Account(Name = 'Dr Evil\'s Dark Energy'));
        insert suppliers;
        List<PricePlan__c> supplierPlans = new List<PricePlan__c>();
        supplierPlans.add(new PricePlan__c(Supplier__c = suppliers[0].Id, Rate__c = 1));
        supplierPlans.add(new PricePlan__c(Supplier__c = suppliers[1].Id, Rate__c = 2));
        supplierPlans.add(new PricePlan__c(Supplier__c = suppliers[2].Id, Rate__c = 10));
        insert supplierPlans;

        Contact client = new Contact(LastName = 'Harry', MeterId__c = 'smart-meter-9527');
        insert client;
    }

    // should generate readings for a client.
    @isTest
    public static void testGenerateReadings(){
        Contact client = [select Id from Contact limit 1];
        ReadingsStub.initReadings(client.Id);
        System.assert([select count() from Reading__c] > 0, 'Incorrect readings quantity.');
    }

    // should not generate readings without a client Id.
    @isTest
    public static void testGenerateReadingsWithoutClientId(){
        ReadingsStub.initReadings(null);
        System.assert([select count() from Reading__c] == 0, 'Incorrect readings quantity.');
    }
}
