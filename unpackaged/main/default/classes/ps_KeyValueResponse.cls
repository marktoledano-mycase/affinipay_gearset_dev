/*
* Test class: ps_KeyValueResponseTest
*/
public class ps_KeyValueResponse {

	public class List_Z {
		public Map<String, String> NameValueMap;
		public List<NameValue> NameValue;
	}

	public class NameValue {
		public String name;
		public String value;
	}

	public List_Z san_list;
	public String raw_json;

	@testVisible
	Private ps_KeyValueResponse() {
		san_list = new List_Z();
		raw_json = 'blah';
		san_list.NameValue = new List<NameValue>();
		NameValue x = new NameValue();
		x.name = 'Tony';
		x.value = 'IronMan';
		san_list.NameValue.add(x);
		san_list.NameValueMap = new Map<String, String>();
		san_list.NameValueMap.put('Bruce', 'Batman');
	}

	public static ps_KeyValueResponse parse(String json) {
		json = ProfitStarsUtils.sanitizeJson(json);
		ps_KeyValueResponse parsed = (ps_KeyValueResponse) System.JSON.deserialize(json, ps_KeyValueResponse.class);
		parsed.raw_json = json;
		parsed.san_list.NameValueMap = new Map<String, String>();
		for (NameValue nv : parsed.san_list.NameValue) {
			parsed.san_list.NameValueMap.put(nv.name, nv.value);
		}

		return parsed;
	}
}