global class AutoConvertLeads {
    @InvocableMethod(label='Convert Leads')
    global static List<AutoConvertLeadsResult> convertLeads(List<AutoConvertLeadsRequest> requests) {
      List<AutoConvertLeadsResult> results = new List<AutoConvertLeadsResult>();
      for (AutoConvertLeadsRequest request : requests) {
        results.add(convertLead(request));
      }
      return results;
    }
  
    public static AutoConvertLeadsResult convertLead(AutoConvertLeadsRequest request) {
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(request.leadId);
      lc.setConvertedStatus(request.convertedStatus);
  
      if (request.accountId != null) {
          lc.setAccountId(request.accountId);
      }
  
      if (request.contactId != null) {
        lc.setContactId(request.contactId);
      }
  
      if (request.overWriteLeadSource != null && request.overWriteLeadSource) {
        lc.setOverwriteLeadSource(request.overWriteLeadSource);
      }
  
      if (request.createOpportunity != null && !request.createOpportunity) {
        lc.setDoNotCreateOpportunity(!request.createOpportunity);
      }
  
      if (request.opportunityName != null) {
        lc.setOpportunityName(request.opportunityName);
      }
  
      if (request.ownerId != null) {
        lc.setOwnerId(request.ownerId);
      }
  
      if (request.sendEmailToOwner != null && request.sendEmailToOwner) {
        lc.setSendNotificationEmail(request.sendEmailToOwner);
      }
  
      Database.LeadConvertResult lcr = Database.convertLead(lc, true);
      if (lcr.isSuccess()) {
        AutoConvertLeadsResult result = new AutoConvertLeadsResult();
        result.accountId = lcr.getAccountId();
        result.contactId = lcr.getContactId();
        result.opportunityId = lcr.getOpportunityId();
        return result;
      } else {
        throw new AutoConvertLeadsException(lcr.getErrors()[0].getMessage());
      }
    }
  
    global class AutoConvertLeadsRequest {
      @InvocableVariable(required=true)
      global ID leadId;
  
      @InvocableVariable(required=true)
      global String convertedStatus;
  
      @InvocableVariable
      global ID accountId;
  
      @InvocableVariable
      global ID contactId;
  
      @InvocableVariable
      global Boolean overWriteLeadSource;
  
      @InvocableVariable
      global Boolean createOpportunity;
  
      @InvocableVariable
      global String opportunityName;
  
      @InvocableVariable
      global ID ownerId;
  
      @InvocableVariable
      global Boolean sendEmailToOwner;
    }
  
    global class AutoConvertLeadsResult {
      @InvocableVariable
      global ID accountId;
  
      @InvocableVariable
      global ID contactId;
  
      @InvocableVariable
      global ID opportunityId;
    }
  
    class AutoConvertLeadsException extends Exception {}
  }