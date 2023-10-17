/*
* Test class: PS_BatchGetMidLidSchedulerTest
*/
public class PS_BatchGetMidLidScheduler implements Schedulable{
   public void execute(SchedulableContext sc){
      PS_BatchGetMidLid b = new PS_BatchGetMidLid(); 
      database.executebatch(b, 1);
   }
}