/*
* Test class for the PS_BatchEnrollScheduler class.
*/
@isTest
private class PS_BatchEnrollSchedulerTest{

	public static String CRON_EXP = '0 0 0 15 3 ? 2024';
	
	static testmethod void enrollSchedulerTest(){
		Test.startTest();
		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PS_BatchEnrollScheduler());
		Test.stopTest();
		System.assert(jobId != null);
	}
}