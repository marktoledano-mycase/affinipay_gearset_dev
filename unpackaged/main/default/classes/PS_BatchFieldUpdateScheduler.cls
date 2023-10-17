/*
* Test class: PS_BatchFieldUpdateSchedulerTest
*/
public with sharing class PS_BatchFieldUpdateScheduler implements Schedulable{
	public void execute(SchedulableContext sc){
		Database.executeBatch(new PS_BatchFieldUpdates(), PSBatchSchedulable_Omnibus.batchSize);
	}
}