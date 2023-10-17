global class PS_BatchLocationScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		PSBatchSchedulable_Omnibus.useFieldPath = True;
		Database.executeBatch(new PS_BatchLocationUpdates(), PSBatchSchedulable_Omnibus.batchSize);
		PSBatchSchedulable_Omnibus.useFieldPath = False;
	}
}