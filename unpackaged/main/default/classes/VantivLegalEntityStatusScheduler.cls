global class VantivLegalEntityStatusScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Database.executeBatch(new VantivLegalEntityStatusBatch(), 2);
    }

}