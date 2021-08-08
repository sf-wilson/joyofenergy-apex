public without sharing class PlansStub {
    public static List<PlanCost> recommend(Id clientId, Integer limits) {
        List<PlanCost> allPlans = UsageStub.getUsageForAllPricePlans(clientId);
        allPlans.sort();
        
        List<PlanCost> results = new List<PlanCost>();
        for (Integer i = 0; i < Math.min(limits, allPlans.size()); i++) {
            results.add(allPlans[i]);
        }
        return results;
    }

    public static List<PlanCost> compare(Id clientId) {
        return UsageStub.getUsageForAllPricePlans(clientId);
    }
}
