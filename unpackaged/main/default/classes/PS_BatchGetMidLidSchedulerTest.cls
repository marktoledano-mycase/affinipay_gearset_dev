/******************************************************************************************************
* copyright © 2016
*
* File		: PS_BatchGetMidLidSchedulerTest.cls
*
* Purpose	: This class tests the schedular class to schedule the batch class
*
* Test class for the PS_BatchGetMidLidScheduler class.
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*09/13/2016			R163756		Rohit Kumar Malik	Create a batch to update MID and LIDs (GET Request) from ProfitStars
*09/13/2016			R164098		Rohit Kumar Malik	MYCase
*
** Latest Changes 09/19/2016
*/
@isTest
private class PS_BatchGetMidLidSchedulerTest{
    public static String CRON_EXP = '0 0 0 15 3 ? 2024';
        
    static testmethod void batchGetMidLidTest(){
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new PS_BatchGetMidLidScheduler());
        Test.stopTest();
        System.assert(jobId != null);
    }
}