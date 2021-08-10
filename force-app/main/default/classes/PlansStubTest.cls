@isTest
public class PlansStubTest {
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

        ReadingsStub.initReadings(client.Id);
    }

    // should compare usage cost for all price plans
    @isTest
    public static void testCompareAllPricePlans(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        List<PlanCost> results = PlansStub.compare(client.Id);
        System.assertEquals(3, results.size(), 'Unexpected plan cost quantity.');
    }

    // should recommend usage cost for all price plans by ordering from cheapest to expensive
    @isTest
    public static void testRecommendPricePlans(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        List<PlanCost> results = PlansStub.recommend(client.Id, 3);
        System.assert(results[0].cost < results[1].cost);
        System.assert(results[1].cost < results[2].cost);
    }

    // should limit recommendation
    @isTest
    public static void testRecommendWithLimits(){
        Contact client = [SELECT Id FROM Contact LIMIT 1];
        List<PlanCost> results = PlansStub.recommend(client.Id, 1);
        System.assertEquals(1, results.size(), 'Unexpected plan cost quantity.');
        results = PlansStub.recommend(client.Id, 5);
        System.assertEquals(3, results.size(), 'Unexpected plan cost quantity.');    
    }
}
