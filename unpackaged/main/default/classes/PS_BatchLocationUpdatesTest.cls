/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class PS_BatchLocationUpdatesTest {
	
	private Static String validCallJson = '{"san_list":{"NameValue":[{"name":"message","value":"success"},{"name":"GUID","value":"MR-148D2AF4158-117F7368"},{"name":"code","value":"201"}]}}';

    static testmethod void batchLocationUpdateTest(){
		List<Account> a = new List<Account>();
		for (Integer i=0;i<10;i++){
			Account acct = new Account(Name = 'TestAccount' + i);
			a.add(acct);
		}
		insert a;
		system.debug('first account id'+a[0].Id);
		
		ValuePlus__c valuePlus = new ValuePlus__c(Account__c=a[0].Id, ps_LocationUpdateRequired__c = true,
																		Successfully_Enrolled_in_Profit_Stars_at__c=System.today(), recordTypeId = TestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'));
		insert valuePlus;
		
		Add_On_Batch__c addOnBatch = new Add_On_Batch__c(ValuePlus__c=valuePlus.Id, Stage__c='Ready for Profitstars');
		insert addOnBatch;
		
		Bank_Account__c bankAccount = new Bank_Account__c(ValuePlus__c=valuePlus.Id, Bank_Account_Add_On_Batch__c=addOnBatch.Id, RoutingNo__c='123456789',
																AccountNo__c='12345678912345678',Ready_for_push_to_ProfitStars__c=true);
		insert bankAccount;
		TestUtils.genTestSettings(true);
		
		Test.setMock(HttpCalloutMock.class,
								 new RestClientCalloutMockFactory(200, 'Success', PS_BatchLocationUpdatesTest.validCallJson, null));
		TestUtils.addRequiredFieldToCustomSetting('Location', 'number_of_locations', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'customer_name', 'Account__r.Account_DBA_Name__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'id', 'id', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'location_id', 'Bank_Account__c.LID__c', true, true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_period_amount', 'Period_Amount__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_period_count', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_single_day_amount', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_single_day_count', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_single_trans_amount', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'settlement_type', 'Number_of_Locations__c', '1', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'Location settings', 'ACH_Type__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'routing_number', 'Bank_Account__r.RoutingNo__c', true, false);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'location_name', 'Bank_Account__r.Account_Label__c', true, false);
		
		Test.startTest();
		PS_BatchLocationUpdates l = new PS_BatchLocationUpdates();
		ID batchprocessid = Database.executeBatch(l);
		Test.stopTest();
	}

	static testmethod void batchLocationUpdateExceptionTest(){
		List<Account> a = new List<Account>();
		for (Integer i=0;i<10;i++){
			Account acct = new Account(Name = 'TestAccount' + i);
			a.add(acct);
		}
		insert a;
		system.debug('first account id'+a[0].Id);
		
		ValuePlus__c valuePlus = new ValuePlus__c(Account__c=a[0].Id, ps_LocationUpdateRequired__c = true,
																		Successfully_Enrolled_in_Profit_Stars_at__c=System.today(), recordTypeId = TestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'));
		insert valuePlus;
		
		Add_On_Batch__c addOnBatch = new Add_On_Batch__c(ValuePlus__c=valuePlus.Id, Stage__c='Ready for Profitstars');
		insert addOnBatch;
		
		Bank_Account__c bankAccount = new Bank_Account__c(ValuePlus__c=valuePlus.Id, Bank_Account_Add_On_Batch__c=addOnBatch.Id, RoutingNo__c='123456789',
																AccountNo__c='12345678912345678',Ready_for_push_to_ProfitStars__c=true);
		// insert bankAccount;
		TestUtils.genTestSettings(true);
		
		Test.setMock(HttpCalloutMock.class,
								 new RestClientCalloutMockFactory(200, 'Success', PS_BatchLocationUpdatesTest.validCallJson, null));
		TestUtils.addRequiredFieldToCustomSetting('Location', 'number_of_locations', 'Number_of_Locations__c', true);
		// TestUtils.addRequiredFieldToCustomSetting('Location', 'customer_name', 'Account__r.Account_DBA_Name__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'id', 'id', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'location_id', 'Bank_Account__c.LID__c', true, true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_period_amount', 'Period_Amount__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_period_count', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_single_day_amount', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_single_day_count', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'max_single_trans_amount', 'Number_of_Locations__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'settlement_type', 'Number_of_Locations__c', '1', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'Location settings', 'ACH_Type__c', true);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'routing_number', 'Bank_Account__r.RoutingNo__c', true, false);
		TestUtils.addRequiredFieldToCustomSetting('Location', 'location_name', 'Bank_Account__r.Account_Label__c', true, false);
		
		Test.startTest();
		PS_BatchLocationUpdates l = new PS_BatchLocationUpdates();
		ID batchprocessid = Database.executeBatch(l);
		Test.stopTest();
	}
}