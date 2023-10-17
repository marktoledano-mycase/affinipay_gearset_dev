/*
* Test Classes required to run  the test cases for this. 
*   1. ValuePlusTriggerMethodHandlerTest
*   2. ValuePlusTriggerAccountHelperTest 
*   3. ValuePlusTriggerOpportunityHelperTest 
*   4. AutoBoardingValuePlusTest
*   5. UpdateMyCasePaymentOppTest
*   6. VPOnBoardingContactPrimaryContactTest
*   7. GiactVerifyServiceTest
*   8. MyCaseValueAddAutoCreateTest
*   9. ValuePlusSubHandlerTest
*  10. ValuePlusTriggerAccountRoundRobinTest
*/
public without sharing class ValuePlusTriggerHandler extends TriggerHandler{
    private ValuePlusTriggerMethodHandler methodHandler;
    
    //runs before insert
    protected override void beforeInsert(){
        methodHandler = new ValuePlusTriggerMethodHandler();
        methodHandler.initBeforeInsert(Trigger.new);
        methodHandler.beforeInsert();
    }
    //runs before update
    protected override void beforeUpdate(){
        methodHandler = new ValuePlusTriggerMethodHandler();
        methodHandler.initBeforeUpdate(Trigger.oldMap, Trigger.newMap, Trigger.new);
        methodHandler.beforeUpdate();
    }
    
    //runs after insert
    protected override void afterInsert(){
        methodHandler = new ValuePlusTriggerMethodHandler();
        methodHandler.initAfterInsert(Trigger.new);
        methodHandler.afterInsert();
    }

    //runs after update
    protected override void afterUpdate(){
        methodHandler = new ValuePlusTriggerMethodHandler();
        methodHandler.initAfterUpdate(Trigger.oldMap, Trigger.newMap, Trigger.new);
        methodHandler.afterUpdate();
    }
}