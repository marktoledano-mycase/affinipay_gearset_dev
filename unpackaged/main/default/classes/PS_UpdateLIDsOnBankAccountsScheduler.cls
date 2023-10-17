/*
* Test class: PS_UpdateLIDsOnBankAccountsSchedulerTest
*/
public class PS_UpdateLIDsOnBankAccountsScheduler implements Schedulable{
   public void execute(SchedulableContext sc){
      PS_UpdateLIDsOnBankAccounts updateLIDBatch = new PS_UpdateLIDsOnBankAccounts();
      Database.executeBatch(updateLIDBatch, 1);
   }
}