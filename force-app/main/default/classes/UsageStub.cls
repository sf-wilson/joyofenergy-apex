public without sharing class UsageStub {
    @testVisible
    private static Decimal average(Id clientId){
        AggregateResult[] results = [select 
                                        AVG(Value__c) aver 
                                        from Reading__c 
                                        where Client__c = :clientId];
        return (Decimal)(results[0].get('aver'));
    }

    @testVisible
    private static Integer timeElapsedInHours(Id clientId){
        Reading__c firstReading = [select Id, ReadingTime__c from Reading__c order by ReadingTime__c limit 1];
        Reading__c lastReading = [select Id, ReadingTime__c from Reading__c order by ReadingTime__c desc limit 1];
        Long firstReadingTime = firstReading.ReadingTime__c.getTime();
        Long lastReadingTime = lastReading.ReadingTime__c.getTime();
        return ((lastReadingTime - firstReadingTime) / 1000 / 3600).intValue();
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
        List<PlanCost> plans = new List<PlanCost>();
        for (PricePlan__c plan : [select Id, Name, Rate__c from PricePlan__c]) {
            plans.add(getPlanCost(plan, clientId));
        }
        return plans;
    }
}
