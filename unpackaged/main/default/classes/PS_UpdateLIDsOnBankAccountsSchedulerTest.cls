/*
* Test class for the PS_UpdateLIDsOnBankAccountsScheduler class.
*/
@isTest
private class PS_UpdateLIDsOnBankAccountsSchedulerTest{
	
	public static String CRON_EXP = '0 0 0 15 3 ? 2024';
		
	static testmethod void batchUpdateLIDsSchedulerTest(){
		Test.startTest();
		TestUtils.genTestSettings(true);
		String jobId = System.schedule('PS_UpdateLIDsOnBankAccountsSchedulerTest',CRON_EXP, new PS_UpdateLIDsOnBankAccountsScheduler());
		Test.stopTest();
		System.assert(jobId != null);
	}
}