/*
* Test class: ProfitStarsUtils_Tests
*/
public class PSBatchSchedulable_Omnibus{

	public static Integer batchSize = 1;
	public static Boolean useFieldPath = false;

	public static void start(){
		//Seconds, Minutes, Hours, Day of week, as shown, the job will run at the first second of every hour.
		String VELOCITY_CRON_EXP      = '0 0 * * * ?';
		String BANK_ACCOUNT_CRON_EXP  = '0 10 * * * ?';
		String LOCATION_CRON_EXP  = '0 20 * * * ?';
		String ADD_ON_BATCH_CRON_EXP  = '0 30 * * * ?';
		//Need to add a 9:40 Batch Enroll - Patrick Maxwell
        //String BATCH_ENROLL_CRON_EXP  = '0 40 12 * * ?';
        
        String BATCH_ENROLL_CRON_TWELVE_EXP  = '0 40 12 * * ?';
        String BATCH_ENROLL_CRON_NINE_EXP  = '0 40 9 * * ?';
		
		String BATCH_APPROVE_CRON_EXP = '0 50 * * * ?';

		// Will run at 0 minutes after the hour. give or take a couple minutes.
		System.schedule('Velocity Updates', VELOCITY_CRON_EXP, new PS_BatchVelocityScheduler());

		// Will run at 10 minutes after the hour. give or take a couple minutes.
		System.schedule('Bank Account Updates', BANK_ACCOUNT_CRON_EXP, new PS_BatchBankAccountScheduler());

		//// Will run at 20 minutes after the hour. give or take a couple minutes.
		System.schedule('Location Updates', LOCATION_CRON_EXP, new PS_BatchLocationScheduler());

		// Will run at 30 minutes after the hour. give or take a couple minutes.
		//System.schedule('Add On Batch Automated Push', ADD_ON_BATCH_CRON_EXP, new PS_BatchAddOnScheduler());

		//// Will run at 40 minutes after the hour. give or take a couple minutes.
		//System.schedule('Batch Enroll', BATCH_ENROLL_CRON_EXP, new PS_BatchEnrollScheduler());
		//Need to add a 9:40 Batch Enroll as well as repeat this 12:40 one - Patrick Maxwell
		
        //Added by Patrick Maxwell
        //Will run at 12:40 minutes after the hour. give or take a couple minutes.
        System.schedule('12:40 Batch Enroll', BATCH_ENROLL_CRON_TWELVE_EXP, new PS_BatchEnrollScheduler());
        
        //Added by Patrick Maxwell
        //Will run at 12:40 minutes after the hour. give or take a couple minutes.
        System.schedule('9:40 Batch Enroll', BATCH_ENROLL_CRON_NINE_EXP, new PS_BatchEnrollScheduler());
        
		// Will run at 50 minutes after the hour. give or take a couple minutes.
		//System.schedule('Batch Enroll Approval', BATCH_APPROVE_CRON_EXP, new PS_BatchEnrollApprovedScheduler());
	}

}