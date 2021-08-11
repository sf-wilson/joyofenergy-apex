public without sharing class UsageStub {
    @testVisible
    private static Decimal average(Id clientId){
        AggregateResult[] results = [SELECT 
                                        AVG(Value__c) aver 
                                        FROM Reading__c 
                                        WHERE Client__c = :clientId];
        return (Decimal)(results[0].get('aver'));
    }

    @testVisible
    private static Integer timeElapsedInHours(Id clientId){
        Reading__c firstReading = [SELECT Id, ReadingTime__c FROM Reading__c WHERE Client__c = :clientId ORDER BY ReadingTime__c LIMIT 1];
        Reading__c lastReading = [SELECT Id, ReadingTime__c FROM Reading__c WHERE Client__c = :clientId ORDER BY ReadingTime__c DESC LIMIT 1];
        Long firstReadingTime = firstReading.ReadingTime__c.getTime();
        Long lastReadingTime = lastReading.ReadingTime__c.getTime();
        // return ((lastReadingTime - firstReadingTime) / 1000 / 3600).intValue();
        return Integer.valueOf(((lastReadingTime - firstReadingTime) / 1000 / 3600));
    }

    @testVisible
    private static Decimal usage(Id clientId) {
        return average(clientId) / timeElapsedInHours(clientId);
    }

    @testVisible
    private static PlanCost getPlanCost(PricePlan__c plan, Id clientId) {
        Decimal cost = usage(clientId) * plan.Rate__c;
        return new PlanCost(plan, cost);
    }

    public static List<PlanCost> getUsageForAllPricePlans(Id clientId) {
        List<PlanCost> planCosts = new List<PlanCost>();
        for (PricePlan__c plan : [select Id, Name, Rate__c from PricePlan__c]) {
            planCosts.add(getPlanCost(plan, clientId));
        }
        return planCosts;
    }
}
