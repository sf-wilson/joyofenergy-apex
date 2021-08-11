// generate reading records based on random num
Integer count = Math.round(Math.random() * 1000);
System.debug('count: ' + count);

DateTime now = DateTime.now();
for(Integer i = 0; i < count; i++) {
    DateTime rtime = now.addHours(-1 * i);
    Decimal val = Math.random() * 5;
    System.debug('rtime: ' + rtime);
    System.debug('val: ' + val);
}

// UsageStub test
Id clientid = '003B000000IuZDqIAN';
// Integer hrs = UsageStub.timeElapsedInHours(clientid);
// System.debug('hrs: ' + hrs);
// 363

List<PlanCost> pcList = UsageStub.getUsageForAllPricePlans(clientid);
System.debug('pcList: ' + pcList);
// pcList: (PlanCost:[cost=0.0068075256821271807162534435261708000, planId=a1kB0000000ThXmIAK, planName=price-plan-1, rate=1.00], PlanCost:[cost=0.0136150513642543614325068870523416000, planId=a1kB0000000ThXnIAK, planName=price-plan-2, rate=2.00], PlanCost:[cost=0.0680752568212718071625344352617080000, planId=a1kB0000000ThXoIAK, planName=price-plan-0, rate=10.00])