/*
* Test class: PS_OutboundBankAccountSchedulerTest
*/
public class PS_OutboundBankAccountUpdatesScheduler implements Schedulable{
	public void execute(SchedulableContext sc){
		Database.executeBatch(new PS_OutboundBankAccountUpdates(), 1);
	}
}