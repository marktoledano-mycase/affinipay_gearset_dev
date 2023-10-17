/*
* Test class for the PS_BatchFieldUpdateScheduler class.
*/
@isTest
private class PS_BatchFieldUpdateSchedulerTest{
	public static String CRON_EXP = '0 0 0 15 3 ? 2024';
		
	static testmethod void batchFieldUpdateTest(){
		Test.startTest();
		TestUtils.genTestSettings(true);
		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PS_BatchFieldUpdateScheduler());
		Test.stopTest();
		System.assert(jobId != null);
	}
}