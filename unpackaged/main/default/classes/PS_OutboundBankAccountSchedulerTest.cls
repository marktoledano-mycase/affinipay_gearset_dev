/*
* Test class for the PS_OutboundBankAccountUpdatesScheduler class.
*/
@isTest
private class PS_OutboundBankAccountSchedulerTest{

	public static String CRON_EXP = '0 0 0 15 3 ? 2024';
	
	static testmethod void test(){
		Test.startTest();
		String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PS_OutboundBankAccountUpdatesScheduler());
		Test.stopTest();
		System.assert(jobId != null);
	}
}