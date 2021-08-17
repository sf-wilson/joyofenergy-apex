public without sharing class PlansStub {
    @AuraEnabled(cacheable=true)
    public static List<PlanCost> recommend(Id clientId, Integer limits) {
        // To solve: List has no rows for assignment to SObject in UsageStub.timeElapsedInHours
        List<PlanCost> results = new List<PlanCost>();
        
        if([SELECT COUNT() FROM Reading__c WHERE Client__c = :clientId] > 0) {
            List<PlanCost> allPlans = UsageStub.getUsageForAllPricePlans(clientId);
            allPlans.sort();
            for (Integer i = 0; i < Math.min(limits, allPlans.size()); i++) 
                results.add(allPlans[i]);
        }

        System.debug('results: ' + results);
        return results;
    }

    public static List<PlanCost> compare(Id clientId) {
        return UsageStub.getUsageForAllPricePlans(clientId);
    }
}