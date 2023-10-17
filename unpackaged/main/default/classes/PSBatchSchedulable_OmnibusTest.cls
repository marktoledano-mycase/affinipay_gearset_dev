@isTest
public with sharing class PSBatchSchedulable_OmnibusTest {
    public static testmethod void testPSBatchSchedulable_OmnibusOmnibus(){
		Test.startTest();
		TestUtils.genTestSettings(true);
        PSBatchSchedulable_Omnibus.start();
		Test.stopTest();
    }
}