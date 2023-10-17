/******************************************************************************************************
* copyright © 2016
*
* File		: PS_BatchGetMidLidTest.cls
*
* Purpose	: This is a batch class for other(any) Update. Thi class identified the records for other update 
*				and instanciates the service class to send the request to profitstars
*
* Test class for the PS_BatchGetMidLid class.
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
public class PS_BatchGetMidLidTest{

	//Creates test data that is used by the unit tests in this class.
    @TestSetup
    public static void createTestData(){
    	TestDataFactory.createCustomSettings();

    	TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
		//insert accounts
		// dm.accountList[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MyCase Account').getRecordTypeId();
		INSERT(dm.accountList);
		
		//insert valuePlus
		dm.valueplusList[0].Account__c = dm.accountList[0].Id;
		dm.valueplusList[0].RecordTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Payments').getRecordTypeId();
		dm.valueplusList[0].Stage__c = 'Sold/Not Started';
		dm.valueplusList[0].OnBoardingStatus__c = 'Transmitted';
		dm.valueplusList[0].Outbound_On_Boarding_Status__c = 'Transmitted';
		INSERT(dm.valuePlusList[0]);

		//insert bank accounts
		dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
		dm.bankAccountList[0].RoutingNo__c = '053000196';
		dm.bankAccountList[0].AccountNo__c = '1234567891';
		INSERT(dm.bankAccountList[0]);
    }

    static testmethod void batchInboundTest(){

    	TestUtils.genTestSettings(true);

    	ValuePlus__c vp = [Select Id, Account_DBA_Name__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];

    	String validCallJson = '{"GetAllMerchants":{"GetAllMerchantsResult":{"WSMerchant":[{"BoardingRefId":"' + vp.Id +'","CreationDateTime":"2019-04-23T10:33:13Z","CustServProviderId":"1234567890","EntityId":"591849","MerchantEnabled":true,"MerchantName":"' + vp.Account_DBA_Name__c +'","Locations":{"WSMerchantLocation":[{"LocationEnabled":true,"LocationId":"4154369","LocationName":"Test Bank Account0"}]}}]}},"HTTPStatusCode":"200"}';

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		Test.startTest();
		PS_BatchGetMidLid batchJob = new PS_BatchGetMidLid();
		ID batchprocessid = Database.executeBatch(batchJob);
		Test.stopTest();

		ValuePlus__c vplus = [Select Id, ProfitStars_Merchant_ID__c, OnBoardingStatus__c, PMT_ProfitStars_On_Boarding_Status__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		System.assertEquals('Approved', vplus.PMT_ProfitStars_On_Boarding_Status__c);
		System.assertEquals('591849', vplus.ProfitStars_Merchant_ID__c);

		Bank_Account__c bank = [Select Id, LID__c, Location_Add_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('Approved', bank.Location_Add_Status__c);
		System.assertEquals('4154369', bank.LID__c);
	}

	static testmethod void batchOutboundTest(){

    	TestUtils.genOutboundTestSettings(true);

    	ValuePlus__c vp = [Select Id, Account_DBA_Name__c  from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];

    	String validCallJson = '{"GetAllMerchants":{"GetAllMerchantsResult":{"WSMerchant":[{"BoardingRefId":"' + vp.Id +'","CreationDateTime":"2019-04-23T10:33:13Z","CustServProviderId":"1234567890","EntityId":"591850","MerchantEnabled":true,"MerchantName":"' + vp.Account_DBA_Name__c  +'","Locations":{"WSMerchantLocation":[{"LocationEnabled":true,"LocationId":"4154370","LocationName":"Test Bank Account0"}]}}]}},"HTTPStatusCode":"200"}';

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		Test.startTest();
		PS_BatchGetMidLid batchJob = new PS_BatchGetMidLid();
		ID batchprocessid = Database.executeBatch(batchJob);
		Test.stopTest();

		ValuePlus__c vplus = [Select Id, Outbound_MID__c, Outbound_On_Boarding_Status__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		// System.assertEquals('Approved', vplus.Outbound_On_Boarding_Status__c);
		// System.assertEquals('591850', vplus.Outbound_MID__c);

		Bank_Account__c bank = [Select Id, Outbound_LID__c, Outbound_Location_Add_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		// System.assertEquals('Approved', bank.Outbound_Location_Add_Status__c);
		// System.assertEquals('4154370', bank.Outbound_LID__c);
	}

	static testmethod void batchMyCaseTest(){

    	TestUtils.genMyCaseInboundTestSettings(true);

		Test.startTest();
    	Account acc = [Select Id, RecordTypeId from Account where Name = 'Test Account0' limit 1];
    	// acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MyCase Account').getRecordTypeId();
    	update acc;

    	ValuePlus__c vp = [Select Id, RecordTypeId, Account_DBA_Name__c , PMT_ProfitStars_On_Boarding_Status__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
    	vp.PMT_ProfitStars_On_Boarding_Status__c = 'Transmitted';
    	vp.RecordTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Payments').getRecordTypeId();
    	update vp;

    	String validCallJson = '{"GetAllMerchants":{"GetAllMerchantsResult":{"WSMerchant":[{"BoardingRefId":"' + vp.Id +'","CreationDateTime":"2019-04-23T10:33:13Z","CustServProviderId":"1234567890","EntityId":"591849","MerchantEnabled":true,"MerchantName":"' + vp.Account_DBA_Name__c  +'","Locations":{"WSMerchantLocation":[{"LocationEnabled":true,"LocationId":"4154369","LocationName":"Test Bank Account0"}]}}]}},"HTTPStatusCode":"200"}';

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		
		PS_BatchGetMidLid batchJob = new PS_BatchGetMidLid();
		ID batchprocessid = Database.executeBatch(batchJob);
		Test.stopTest();

		ValuePlus__c vplus = [Select Id, ProfitStars_Merchant_ID__c, PMT_ProfitStars_On_Boarding_Status__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		System.assertEquals('Approved', vplus.PMT_ProfitStars_On_Boarding_Status__c);
		System.assertEquals('591849', vplus.ProfitStars_Merchant_ID__c);

		Bank_Account__c bank = [Select Id, LID__c, Location_Add_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('Approved', bank.Location_Add_Status__c);
		System.assertEquals('4154369', bank.LID__c);
	}
}