/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is the apex controller for the MycaseValuePlusButtons component. 
* 
* @test           MyCasePaymentsButtonsControllerTest
* Referred from   MycaseValuePlusButtons.cmp
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Hunter Hamakar   <hunter.hamakar@appfolio.com>
* @modifiedBy     Vijay Reddy      <vijay.reddy@appfolio.com>
* @version        1.0
* @created        2020-08-06
* @modified       2020-08-11
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            Hunter and Vijay
* 2020-08-06      Initial Creation
*      
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class MyCasePaymentsButtonsController {
    
	@AuraEnabled
	public static String processVPlusRecord(String recordId, String processName){	
		try{
            //define output string - should be changed in switch case
            String result = '';
            
            switch on processName{
                //run through the routing options, call appropriate methods
                
                when 'veloInbound'{                    
                    result = ps_buttonMethods.callVelocity(recordId);                 
                }
                when 'psInbound'{
					result = ps_buttonMethods.callEnrollment(recordId);
                }
                when 'vantivEnroll'{
                    result = VantivButtons.callLegalEntity(recordId);
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