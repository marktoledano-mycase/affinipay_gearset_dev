global class PS_BatchVelocityScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		PSBatchSchedulable_Omnibus.useFieldPath = True;
		Database.executeBatch(new ps_BatchVelocityUpdate('echeck'), PSBatchSchedulable_Omnibus.batchSize);
		PSBatchSchedulable_Omnibus.useFieldPath = False;
	}
}