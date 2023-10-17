/*
* Test class for the PS_BatchBankAccountScheduler class.
*/
@isTest
private class PS_BatchBankAccountSchedulerTest{
	public static String CRON_EXP = '0 0 0 15 3 ? 2024';
	
	static testmethod void test(){
		Test.startTest();
		TestUtils.genTestSettings(true);
		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PS_BatchBankAccountScheduler());
		Test.stopTest();
		System.assert(jobId != null);
	}
}