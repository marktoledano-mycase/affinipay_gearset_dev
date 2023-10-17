@isTest
private class VantivScenarioValidations {
	    // SOLUNUS MODIFICATION TO PROD: 
		@isTest
		private static void dummyTest() {
		   System.assertEquals(0, 0);
		}
	public class VantivResults
	{
		 String result;
		 Boolean didPass;
		 
		 public VantivResults(String r, Boolean b)
		 {
		 	this.result = r;
		 	this.didPass = b;
		 }
	}
	static testmethod void createLegalEntitySuccess(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callLegalEntity(vp.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(vr.didPass);
		Test.stopTest();
	}
	
	static testmethod void createLegalEntityFailure(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntityFailedResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callLegalEntity(vp.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Create legal entity request failed with following errors'));
		Test.stopTest();
	}
	
	static testmethod void createLegalEntityDuplicate(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntityDuplicateResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callLegalEntity(vp.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Merchat was already enrolled with vantiv'));
		Test.stopTest();
	}
	
	static testmethod void createLegalEntityException(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntityFailedResponse, 400));
		
		Test.startTest();
		String result = VantivButtons.callLegalEntity(vp.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Response code was 400 which indicates a failure'));
		Test.stopTest();
	}
	
	static testmethod void updateLegalEntitySuccess(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callLegalEntityUpdateReq(vp.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(vr.didPass);
		Test.stopTest();
	}
	
	static testmethod void updateLegalEntityFailure(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		vp.Vantiv_Legal_Entity_Id__c = null;
		update vp;
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntityFailedResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callLegalEntityUpdateReq(vp.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Legal entity id unavailable'));
		Test.stopTest();
	}
	static testmethod void updateLegalEntityException(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntityFailedResponse, 404));
		
		Test.startTest();
		String result = VantivButtons.callLegalEntityUpdateReq(vp.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Response code was 404 which indicates a failure'));
		Test.stopTest();
	}
	
	static testmethod void createSubMerchantSuccess(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callSubMerchantCreateReq(ba.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(vr.didPass);
		Test.stopTest();
	}
	static testmethod void createSubMerchantFailure(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantFailedResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callSubMerchantCreateReq(ba.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Create Sub-Merchant request failed with following errors'));
		Test.stopTest();
	} 
	static testmethod void createSubMerchantDuplicate(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantDuplicateResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callSubMerchantCreateReq(ba.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Sub-Merchat was already enrolled with vantiv'));
		Test.stopTest();
	}
	static testmethod void createSubMerchantException(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantFailedResponse, 404));
		
		Test.startTest();
		String result = VantivButtons.callSubMerchantCreateReq(ba.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Response code was 404 which indicates a failure'));
		Test.stopTest();
	} 
	
	static testmethod void updateSubMerchantSuccess(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccountWithSubmerchantId(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callSubMerchantUpdateReq(ba.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(vr.didPass);
		Test.stopTest();
	}
	
	static testmethod void updateSubMerchantFailure(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccountWithSubmerchantId(true, vp.Id);
		ba.Vantiv_Sub_Merchant_Id__c = null;
		update ba;
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantFailedResponse, 200));
		
		Test.startTest();
		String result = VantivButtons.callSubMerchantUpdateReq(ba.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Legal Entity id and/or SubMerchant id is unavailable'));
		Test.stopTest();
	}
	
	static testmethod void updateSubMerchantException(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccountWithSubmerchantId(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantFailedResponse, 404));
		
		Test.startTest();
		String result = VantivButtons.callSubMerchantUpdateReq(ba.Id);
		VantivResults vr = (VantivResults) JSON.deserialize(result, VantivResults.class);
		System.debug(vr);
		System.assert(!vr.didPass);
		System.assert(vr.result.containsIgnoreCase('Response code was 404 which indicates a failure'));
		Test.stopTest();
	} 
	
	static testmethod void getLegalEntitySuccess(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		//Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		//VantivButtons.callLegalEntity(vp.Id);
		VantivLegalEntityRetrieveReq req = new VantivLegalEntityRetrieveReq(vp.Id);
		System.debug(req.response);
		System.assert(req.response.isSuccess);
		Test.stopTest();
	}
	
	static testmethod void getSubMerchantSuccess(){
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccountWithSubmerchantId(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		//VantivButtons.callSubMerchantCreateReq(ba.Id);
		VantivSubMerchantRetrieveReq req = new VantivSubMerchantRetrieveReq(ba.Id);
		System.debug(req.response);
		System.assert(req.response.isSuccess);
		Test.stopTest();
	}
}