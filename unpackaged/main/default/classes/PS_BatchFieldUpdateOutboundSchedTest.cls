/*
* Test class for the PS_BatchFieldUpdateOutboundSchedTest class.
*/
@isTest
private class PS_BatchFieldUpdateOutboundSchedTest{

	public static String CRON_EXP = '0 0 0 15 3 ? 2024';
		
	static testmethod void batchFieldUpdateTest(){
		Test.startTest();
		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PS_BatchFieldUpdateOutboundScheduler());
		Test.stopTest();
		System.assert(jobId != null);
	}
}