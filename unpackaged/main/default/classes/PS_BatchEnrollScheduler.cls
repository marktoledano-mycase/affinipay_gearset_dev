/*
* Test class: PS_BatchEnrollSchedulerTest
*/
public class PS_BatchEnrollScheduler implements Schedulable{

	public void execute(SchedulableContext context){
		ProfitStarsBatchEnroll enroll = new ProfitStarsBatchEnroll();
		Database.executeBatch(enroll, 1);
	}
}