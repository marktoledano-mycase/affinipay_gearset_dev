/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is the apex controller for the MyCaseBankAccountButtons component. 
* 
* @test           MyCaseBankAccountButtonsControllerTest
* Referred from   MyCaseBankAccountButtons.cmp
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Vijay Reddy      <vijay.reddy@appfolio.com>
* @version        1.0
* @created        2020-08-11
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            Vijay
* 2020-08-11      Initial Creation
*      
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class MyCaseBankAccountButtonsController{
    
    @AuraEnabled
	public static String processBankRecord(String recordId, String processName){	
		try{
            //define output string - should be changed in switch case
            String result = '';
            
            switch on processName{
                //run through the routing options, call appropriate methods
                
                when 'pushBankToPS'{                    
                    result = ps_buttonMethods.callLocation(recordId);                   
                }
                when 'addBankToVantiv'{
					result = VantivButtons.callSubMerchantCreateReq(recordId);
                }
                when 'updateBankInVantiv'{
					result = VantivButtons.callSubMerchantUpdateReq(recordId);
                }
			}
            
            //if the output string is still empty, throw an error
            if(result == ''){
                String err = 'Switch case failed to run any methods, please notify your Salesforce team';
                AuraHandledException except = new AuraHandledException(err);
                except.setMessage(err);
                throw except;
            }else{
            	return result;    
            }
		} catch(Exception e){
            //throw all other exception message
            if(Test.isRunningTest()){
                return 'error thrown: ' + e.getMessage();
            }else{
                throw new AuraHandledException(e.getMessage());
            }
        }
	}
}