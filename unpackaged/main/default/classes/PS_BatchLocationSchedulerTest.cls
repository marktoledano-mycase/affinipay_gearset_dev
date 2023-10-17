@isTest
private class PS_BatchLocationSchedulerTest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2024';
		
		static testmethod void batchLocationTest() {
			Test.startTest();
			String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP, new PS_BatchLocationScheduler());
			Test.stopTest();
			System.assert(jobId!= Null);
		}
}