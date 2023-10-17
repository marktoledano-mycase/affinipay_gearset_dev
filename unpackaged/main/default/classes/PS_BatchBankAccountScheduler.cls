/*
* Test class: PS_BatchBankAccountSchedulerTest
*/
public class PS_BatchBankAccountScheduler implements Schedulable{
	public void execute(SchedulableContext sc){
		PSBatchSchedulable_Omnibus.useFieldPath = True;
		Database.executeBatch(new PS_BatchBankAccountUpdates(), PSBatchSchedulable_Omnibus.batchSize);
		PSBatchSchedulable_Omnibus.useFieldPath = False;
	}
}