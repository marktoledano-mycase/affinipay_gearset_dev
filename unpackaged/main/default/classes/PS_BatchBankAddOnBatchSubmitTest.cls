@isTest
private class PS_BatchBankAddOnBatchSubmitTest {
	static testmethod void buttonMethodsTest(){
		List<Account> a = new List<Account>();
		for (Integer i=0;i<10;i++){
			Account acct = new Account(Name = 'TestAccount' + i);
			a.add(acct);
		}
		insert a[0];
		system.debug('first account id'+a[0].Id);
		
		ValuePlus__c valuePlus = new ValuePlus__c(Account__c=a[0].Id, ps_LocationUpdateRequired__c=true,
														ps_VelocityUpdateRequired__c = True, Successfully_Enrolled_in_Profit_Stars_at__c=System.today(), recordTypeId = TestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'));
		insert valuePlus;
		
		/*Add_On_Batch__c addOnBatch = new Add_On_Batch__c(ValuePlus__c=valuePlus.Id, Stage__c='Ready for Profitstars');
		insert addOnBatch;*/
		
		Add_On_Batch__c bankAccountAddon = new Add_On_Batch__c (ValuePlus__c = valuePlus.Id);
		insert bankAccountAddon;

		Bank_Account__c bankAccount = new Bank_Account__c(ValuePlus__c=valuePlus.Id, RoutingNo__c='123456789',
										AccountNo__c='12345678912345678',Ready_for_push_to_ProfitStars__c=true,
										ps_LocationUpdateRequired__c = True, Bank_Account_Add_On_Batch__c= bankAccountAddon.id,
										Outbound_Location_Add_Status__c='Ready To Transmit');
		insert bankAccount;
		
		Test.startTest();
		String response = ps_BankAccountAddonbuttonMethods.CallBankAddonBatch(bankAccountAddon.Id);
		String response1 = ps_BankAccountAddonbuttonMethods.CallBankAddonBatchOutbound(bankAccountAddon.Id);
		Test.stopTest();
        // Set the mock callout mode
       //Test.setMock(HttpCalloutMock.class, new ProfitStarsMockResponse());
	}
}