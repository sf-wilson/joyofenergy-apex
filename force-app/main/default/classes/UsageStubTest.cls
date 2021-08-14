@isTest
public with sharing class UsageStubTest {
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

        DateTime now = DateTime.now();
        List<Reading__c> readings = new List<Reading__c>();
        for (Integer i = 0; i < 5; i++) {
            Reading__c reading = new Reading__c();
            reading.Client__c = client.Id;
            reading.ReadingTime__c = now.addHours(-1 * i);// 0,-1,-2,-3,-4
            reading.Value__c = i;// 0,1,2,3,4
            readings.add(reading);
        }
        insert readings;
    }

    // should average all readings for a client
    @isTest
    public static void testAverage(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        Decimal averageReadings = UsageStub.average(client.Id);
        // System.assertEquals(3, averageReadings);
        System.assertEquals(2, averageReadings);// (0+1+2+3+4) / 5
    }

    // should get time elapsed in hours for all readings for a client
    @isTest
    public static void testTimeElapsedInHours(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        Decimal hours = UsageStub.timeElapsedInHours(client.Id);
        System.assertEquals(4, hours);// 0 - (-4)
    }

    // should get usage for all readings for a client 
    @isTest
    public static void testUsage(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        Decimal usage = UsageStub.usage(client.Id);
        // System.assertEquals(0.75, usage);
        System.assertEquals(0.5, usage);// 2 / 4 = 0.5
    }

    // should get usage cost for all readings for all price plans
    @isTest
    public static void testAllPricePlans(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        List<PlanCost> plans = UsageStub.getUsageForAllPricePlans(client.Id);
        plans.sort();
        // System.assertEquals(0.75, plans[0].cost);
        // System.assertEquals(1.5, plans[1].cost);
        // System.assertEquals(7.5, plans[2].cost);
        System.assertEquals(0.5, plans[0].cost);// 0.5 * 1
        System.assertEquals(1, plans[1].cost);// 0.5 * 2
        System.assertEquals(5, plans[2].cost);// 0.5 * 10
    }
}