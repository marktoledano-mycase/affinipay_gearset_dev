/*
* Test class: ps_GuidRespTest
*/
public class ps_GuidResp{

	//Class for Enrollment response
	public class PS_Resp{
		public String result;
		public String transaction_id;
		public String code;
		public String message;
		public String application_id;
		public String raw_json;
	}

	public class PS_Resp_Maint{
		public String caseNumber;
		public String success;
		public String errorMessage;
		public String errorCode;
	}

	//Class for GetAllMerchants response
	public class GetAllMerchantsResults{
		public GetAllMerchants getAllMerchants;
		public String httpStatusCode;
		public String errorMessage;
		public String errorCode;
		//public String raw_json;
	}

	public class GetAllMerchantsResult{
		public List<WSMerchant> wsMerchant;
	}

	public class WSMerchant{
		public String boardingRefId;
		public String creationDateTime;
		public String custServProviderId;
		public String entityId;
		public Boolean merchantEnabled;
		public String merchantName;
		public Locations locations;
	}

	public class GetAllMerchants{
		public GetAllMerchantsResult getAllMerchantsResult;
	}

	public class Locations{
		public List<WSMerchantLocation> wsMerchantLocation;
	}

	public class WSMerchantLocation{
		public Boolean locationEnabled;
		public String locationId;
		public String locationName;
	}

	//Class for GetAllLocations response
	public class GetAllLocationsResults{
		public GetAllLocations getAllLocations;
		public String httpStatusCode;
	}

	public class GetAllLocations{
		public GetAllLocationsResult getAllLocationsResult;
	}

	public class GetAllLocationsResult{
		public List<WSLocation> wsLocation;
	}

	public class WSLocation{
		public String accountNumberLast4;
		public String accountType;
		public String custServProviderId;
		public String customerLocationNumber;
		public String entityId;
		public Boolean locationEnabled;
		public String locationId;
		public String locationName;
		public String merchantName;
		public String routingNumber;
	}

	//Class for GetLocationByLocationId response
	public class GetLocationByLocationIdResults{
		public String httpStatusCode;
		public GetLocationByLocationId getLocationByLocationId;
	}

	public class GetLocationByLocationId{
		//public GetLocationByLocationIdResult GetLocationByLocationIdResult;
		public WSLocation getLocationByLocationIdResult;
	}

	//Class for GetLocationByLocationName response
	public class GetLocationByLocationNameResults{
		public String httpStatusCode;
		public GetLocationByLocationName getLocationByLocationName;
		public String errorMessage;
		public String errorCode;
	}

	public class GetLocationByLocationName{
		public WSLocation getLocationByLocationNameResult;
	}

	//Class for GetVelocitySettingsByLocationId response
	public class GetVelocitySettingsByLocationIdResults{
		public GetVelocitySettingsByLocationId getVelocitySettingsByLocationId;
		public String httpStatusCode;
	}

	public class GetVelocitySettingsByLocationId{
		public GetVelocitySettingsByLocationIdResult getVelocitySettingsByLocationIdResult;
	}

	public class GetVelocitySettingsByLocationIdResult{
		public WSVelocitySettings wsVelocitySettings;
	}

	public class WSVelocitySettings{
		public String custServProviderId;
		public String dailyPercentageWarning;
		public String description;
		public String entityId;
		public String location;
		public String maxPeriodAmount;
		public String maxPeriodCount;
		public String maxSingleDayAmount;
		public String maxSingleDayCount;
		public String maxSingleTransactionAmount;
		public String merchantName;
		public String periodPercentageWarning;
		public String singleAmountPercentageWarning;
		public String vsId;
		public Boolean velocityEnabled;
		public List<ACHTransactionTypes> achTransactionTypes;
		public List<EnabledExceptions> enabledExceptions;
		public List<OperationType> operationType;
		public List<SettlementType> settlementType;
	}

	public class SettlementType{
		public String wsSettlementType;
	}

	public class EnabledExceptions{
		public String wsVelocityExceptions;
	}

	public class ACHTransactionTypes{
		public String wsACHTransactionType;
	}

	public class OperationType{
		public String wsOperationType;
	}

	//Class for GetVelocitySettingsByMerchantId response
	public class GetVelocitySettingsByMerchantIdResults{
		public GetVelocityByMerchant getVelocityByMerchant;
		public String httpStatusCode;
		public String errorMessage;
		public String errorCode;
	}

	public class GetVelocityByMerchant{
		public GetVelocitySettingsByMerchantIdResult getVelocitySettingsByMerchantIdResult;
	}

	public class GetVelocitySettingsByMerchantIdResult{
		public List<WSVelocitySettings> wsVelocitySettings;
	}

	public static PS_Resp parse_new(String json){
		System.debug('The response Json is ' + json);
		json = ProfitStarsUtils.sanitizeJson(json);
		System.debug('The sanitized Json is ' + json);
		PS_Resp parsed = (PS_Resp) System.JSON.deserialize(json, PS_Resp.class);
		parsed.raw_json = json;
		System.debug('The PS_Resp parsed is ' + parsed);
		
		return parsed;
	}
}