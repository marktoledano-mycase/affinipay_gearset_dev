/*
* Test class: PS_BatchFieldUpdateOutboundSchedTest
*/
public with sharing class PS_BatchFieldUpdateOutboundScheduler implements Schedulable{
	public void execute(SchedulableContext sc){
		Database.executeBatch(new PS_BatchFieldUpdatesForOutbound(), PSBatchSchedulable_Omnibus.batchSize);
	}
}