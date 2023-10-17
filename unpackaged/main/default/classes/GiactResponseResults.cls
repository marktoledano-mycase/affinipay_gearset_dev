/**********************************************************************************************************************
* 
* copyright © 2017
* File      : GiactResponseResults.cls
* Purpose   : The main purpose of this class is to Giact Response. Code Deserializes the response into 
* GiactResponseResults. This also contains all the Error if there are any. 
*
* @author Rohit Kumar Malik
* @version 1.0
* @since 2017-10-20
**********************************************************************************************************************/
public class GiactResponseResults {
	
 	public static Map <String, Object> parse(String json) {
		json = GIACTUtils.sanitizeJson(json);
		Map <String, Object>  gResponse;
		System.debug('FileName-GiactResponseResults: Sanitized Json Response - '+json);
		gResponse =  (Map <String, Object>) System.JSON.deserializeUntyped(json);
		return gResponse;
	}

	public static Errors parseErrors (String json) {
		json = GIACTUtils.sanitizeJson(json);
		Errors parsed =  (Errors) System.JSON.deserialize(json, Errors.class);
		return parsed;
	}

	public class Errors {
		public List <Error> errors = new List<Error> ();
	}

	public class Error {
		public String detail {get; set;}
		public String title {get; set;}
		public String status {get; set;}
	}
}