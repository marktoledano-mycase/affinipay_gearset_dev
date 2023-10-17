public without sharing class InformationStrings {
    // Error message strings ZUC stands for Zuora Unit count
    public static final String ZUC_SUCCESS_UPDATE = 'Successfully updated the subscription. || Account Name : {0} || Subscription Name/Number : {1} || + {2}' ;
    public static final String ZUC_INVALID_SUBNAME = 'The subscription name don\'t start with A-. We don\'t process these subscription. || Account Name : {0} || Account Id : {1} || ';

    public static final String ZUC_NOTFOUND_RATEPLAN = 'There is no Rate Plan Id found. Please contact the Zuora/Salesforce administrator. || Account Name : {0} || Subscription Name/Number :  {1} || ';   
    public static final String ZUC_NOTFOUND_RATEPLANCHARGE = 'There is no product Rate Plan charge Id found. Please contact the Zuora/Salesforce administrator.|| Account Name : {0} || Subscription Name/Number : {1} || ';

    public static final String ZUC_FAILED_GETSUBSCRIPTION = 'Subscription GET failed to retrieve the subscription information. Please contact the Zuora/Salesforce administrator.|| Account Name : {0} || Subscription Name/Number : {1} || ';
    public static final String ZUC_FAILED_PUTSUBSCRIPTION = 'Subscription PUT failed to update the subscription information. Please contact the Zuora/Salesforce administrator. || Account Name : {0} || Subscription Name/Number : {1} || ';

    public static String formattedStr (String toFormat, List<String> arguments) {
        return String.format(toFormat, arguments);
    }

    //Id's needed for Classes
    //Asset RecordTypes
    // public static final Id assetPropertyManagementId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Property Management').getRecordTypeId();
    // public static final Id assetInvestmentManagementId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Investment Management').getRecordTypeId();
    // public static final Id assetDynastyId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Dynasty').getRecordTypeId();

    //Contact RecordTypes
    // public static final Id contactMyCaseId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('MyCase').getRecordTypeId();
    // public static final Id contactPMId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('PM').getRecordTypeId();
    // public static final Id contactConsumerId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();

    //Lead RecordTypes
    // public static final Id leadPMSalesId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('PM Sales').getRecordTypeId();

    //Case RecordTypes
    public static final Id caseMyCaseSupportId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MyCase Support').getRecordTypeId();
    // public static final Id caseEngagementId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Engagement').getRecordTypeId();
    // public static final Id caseAutoBoardingId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Auto Boarding').getRecordTypeId();
    // public static final Id caseMailingServiceId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mailing Service').getRecordTypeId();
    public static final Id caseRiskId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Risk').getRecordTypeId();
    // public static final Id caseTenantScreeningId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Tenant Screening').getRecordTypeId();
    // public static final Id casePropertyManagementId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Property Management').getRecordTypeId();
    // public static final Id caseMCCInAppId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MCC In App').getRecordTypeId();
    // public static final Id casePaymentsAdoptionId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Payments Adoption').getRecordTypeId();
    // public static final Id caseWebsiteId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Website').getRecordTypeId();
    // public static final Id caseBillingId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
    // public static final Id caseRentlinxId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Rentlinx').getRecordTypeId();
    // public static final Id caseBillingApprovedAdjustmentId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Billing - Approved Adjustment').getRecordTypeId();
    // public static final Id caseChargebackId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chargeback').getRecordTypeId();
    // public static final Id caseContactCenterId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contact Center').getRecordTypeId();
    // public static final Id caseInsuranceClaimId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
    // public static final Id caseMCCId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MCC').getRecordTypeId();
    public static final Id casePaymentServicesId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Payment Services').getRecordTypeId();
    // public static final Id caseLISAId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LISA').getRecordTypeId();
    // public static final Id caseInvestmentManagementId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Investment Management').getRecordTypeId();
    // public static final Id caseVPSupportScreeningId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('V+ Support - Screening').getRecordTypeId();
    // public static final Id caseMyCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MyCase').getRecordTypeId();
    // public static final Id caseMyCaseWebsitesId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MyCase Websites').getRecordTypeId();
    // public static final Id caseUtilityManagementId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Utility Management').getRecordTypeId();
    // public static final Id caseImPaymentServicesId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IM Payment Services').getRecordTypeId();
    // public static final Id casePublicRecordsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Public Records').getRecordTypeId();
    // public static final Id caseAPMOpsEnablementId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APM Ops/Enablement').getRecordTypeId();

    //Opportunity RecordTypes
    // public static final Id opportunityPmSalesId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PM Sales').getRecordTypeId();
    // public static final Id opportunityImSalesId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IM Sales').getRecordTypeId();
    // public static final Id opportunityPmValueId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PM Value+').getRecordTypeId();
    // public static final Id opportunityImValueId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IM Value+').getRecordTypeId();
    // public static final Id opportunityPartnerId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
    // public static final Id opportunityMyCaseId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MyCase').getRecordTypeId();
    // public static final Id opportunityMyCaseValueId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MyCase Value+').getRecordTypeId();
    // public static final Id opportunityDynastyId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dynasty').getRecordTypeId();
    // public static final Id opportunityMAId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('M & A').getRecordTypeId();

    //Account RecordTypes
    // public static final Id accountPropertyManagementId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property Management').getRecordTypeId();
    public static final Id accountCustomerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

    //Survey RecordTypes
    // public static final Id surveyAPMNPSId = Schema.SObjectType.Survey__c.getRecordTypeInfosByName().get('APM: NPS').getRecordTypeId();
    // public static final Id surveyAPMSuccessId = Schema.SObjectType.Survey__c.getRecordTypeInfosByName().get('APM: Success').getRecordTypeId();

    //ValuePlus RecordTypes
    public static final Id vPlusAPMPaymentsId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Payments').getRecordTypeId();
    public static final Id vPlusIMPaymentsId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('IM Payments').getRecordTypeId();
    // public static final Id vPlusIMWebsitesId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('IM Websites').getRecordTypeId();
    // public static final Id vPlusAPMScreeningId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Screening').getRecordTypeId();
    // public static final Id vPlusAPMLisaId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM LISA').getRecordTypeId();
    // public static final Id vPlusAPMWebsiteId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Website').getRecordTypeId();
    // public static final Id vPlusAPMCollectionsId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Collections').getRecordTypeId();
    // public static final Id vPlusAPMMaintenanceContactCenterId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Maintenance Contact Center').getRecordTypeId(); 
    // public static final Id vPlusAPMLeasingContactCenterId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Leasing Contact Center').getRecordTypeId(); 
    // public static final Id vPlusAPMInsuranceId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Insurance').getRecordTypeId(); 
    // public static final Id vPlusAPMUtilityManagementId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Utility Management').getRecordTypeId();    
    public static final Id vPlusMycasePaymentsId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Payments').getRecordTypeId(); 
    public static final Id vPlusMycaseWebsitesId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Websites').getRecordTypeId();
    // public static final Id vPlusAPMPremiumLeadsId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Premium Leads').getRecordTypeId();
    // public static final Id vPlusAPMMailingServiceId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Mailing Service').getRecordTypeId();
    // public static final Id vPlusAPMAutomatedAPId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Automated AP').getRecordTypeId();

    //Request RecordTypes
    // public static final Id requestUserMaintenanceId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('User Maintenance').getRecordTypeId();
    // public static final Id requestRecordMaintenanceMassUpdateId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Record Maintenance/Mass Update').getRecordTypeId();
    // public static final Id requestTechDebtMaintenanceId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Tech Debt/Maintenance').getRecordTypeId();
    // public static final Id requestBugErrorId = Schema.SObjectType.Request__c.getRecordTypeInfosByName().get('Bug/Error').getRecordTypeId();

    //Real Estate Onboarding RecordTypes
    // public static final Id imREOId = Schema.SObjectType.Real_Estate_Onboarding__c.getRecordTypeInfosByName().get('IM Onboarding').getRecordTypeId();
    // public static final Id apmREOId = Schema.SObjectType.Real_Estate_Onboarding__c.getRecordTypeInfosByName().get('Property Management Onboarding').getRecordTypeId();

    //Task RecordTypes
    // public static final Id taskDefaultId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Default').getRecordTypeId();
    // public static final Id taskMyCaseId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('MyCase').getRecordTypeId();

    //GIdentifyEntityInformation RecordTypes
    public static final Id gIdentifyTinCheckId = Schema.SObjectType.GIdentifyEntityInformation__c.getRecordTypeInfosByName().get('TinCheck').getRecordTypeId();

    //Database RecordTypes
    // public static final Id databaseInvestmentManagementId = Schema.SObjectType.Database__c.getRecordTypeInfosByName().get('Investment Management').getRecordTypeId();
    // public static final Id databasePropertyManagementId = Schema.SObjectType.Database__c.getRecordTypeInfosByName().get('Property Management').getRecordTypeId();

    //Product Adoption RecordTypes
    // public static final Id productAdoptionAPMPlusId = Schema.SObjectType.Product_Adoption__c.getRecordTypeInfosByName().get('APM+').getRecordTypeId();
}