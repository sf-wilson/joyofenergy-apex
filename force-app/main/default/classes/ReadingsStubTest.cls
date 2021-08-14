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
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        ReadingsStub.initReadings(client.Id);
        System.assert([SELECT count() FROM Reading__c] > 0, 'Incorrect readings quantity.');
    }

    // should not generate readings without a client Id.
    @isTest
    public static void testGenerateReadingsWithoutClientId(){
        ReadingsStub.initReadings(null);
        System.assert([SELECT count() FROM Reading__c] == 0, 'Incorrect readings quantity.');
    }

    // should not generate readings if there is already some readings under this client.
    @isTest
    public static void testGenerateReadingsWhenExistReadings(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        Reading__c reading = new Reading__c(
            Client__c = client.Id,
            ReadingTime__c = DateTime.newInstance(2021, 8, 8, 6, 8, 26),
            Value__c = 4.332);
        insert reading;
        ReadingsStub.initReadings(client.Id);
        System.assert([SELECT count() FROM Reading__c] == 1, 'Incorrect readings quantity.');
    }
}