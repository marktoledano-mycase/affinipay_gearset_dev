@isTest
private class ps_BatchVelocityUpdateTest {
	static testmethod void batchVelocityUpdateTest(){
		TestDataFactory.createCustomSettings();
		List<Account> a = new List<Account>();
		for (Integer i=0;i<10;i++){
			Account acct = new Account(Name = 'TestAccount' + i);
			a.add(acct);
		}
		insert a;
		system.debug('first account id'+a[0].Id);
		
		ValuePlus__c valuePlus = new ValuePlus__c(Account__c=a[0].Id, ps_VelocityUpdateRequired__c = True,
																		Successfully_Enrolled_in_Profit_Stars_at__c=System.today(), recordTypeId = TestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'));
		insert valuePlus;
		
		Add_On_Batch__c addOnBatch = new Add_On_Batch__c(ValuePlus__c=valuePlus.Id, Stage__c='Ready for Profitstars');
		insert addOnBatch;
		
		Bank_Account__c bankAccount = new Bank_Account__c(ValuePlus__c=valuePlus.Id, Bank_Account_Add_On_Batch__c=addOnBatch.Id, RoutingNo__c='123456789',
																AccountNo__c='12345678912345678',Ready_for_push_to_ProfitStars__c=true);
		insert bankAccount;
		TestUtils.genTestSettings(true);
		Test.startTest();
		ps_BatchVelocityUpdate velocityJob = new ps_BatchVelocityUpdate();
		ID batchprocessid = Database.executeBatch(velocityJob);
		Test.stopTest();
	}

	static testmethod void batchVelocityUpdateTest2(){
		TestDataFactory.createCustomSettings();
		List<Account> a = new List<Account>();
		for (Integer i=0;i<10;i++){
			Account acct = new Account(Name = 'TestAccount' + i);
			a.add(acct);
		}
		insert a;
		system.debug('first account id'+a[0].Id);
		
		ValuePlus__c valuePlus = new ValuePlus__c(Account__c=a[0].Id, ps_VelocityUpdateRequired__c = True,
																		Successfully_Enrolled_in_Profit_Stars_at__c=System.today(), recordTypeId = TestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'));
		insert valuePlus;
		
		Add_On_Batch__c addOnBatch = new Add_On_Batch__c(ValuePlus__c=valuePlus.Id, Stage__c='Ready for Profitstars');
		insert addOnBatch;
		
		Bank_Account__c bankAccount = new Bank_Account__c(ValuePlus__c=valuePlus.Id, Bank_Account_Add_On_Batch__c=addOnBatch.Id, RoutingNo__c='123456789',
																AccountNo__c='12345678912345678',Ready_for_push_to_ProfitStars__c=true);
		insert bankAccount;
		TestUtils.genTestSettings(true);
		Test.startTest();
		ps_BatchVelocityUpdate velocityJob = new ps_BatchVelocityUpdate('echeck');
		ID batchprocessid = Database.executeBatch(velocityJob);
		Test.stopTest();
	}
}