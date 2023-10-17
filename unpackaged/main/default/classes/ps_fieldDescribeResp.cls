// Test Class - ps_fieldDescribeRespTest
Public class ps_fieldDescribeResp {
	public class List_Z {
		public String name {get; set;}
		public String type {get; set;}
		public String required {get; set;}
		public String required_if {get; set;}
		public String length {get; set;}
		public String disabled_if {get; set;}
	}

	public List<List_Z> san_list;

	@testVisible
	Private ps_fieldDescribeResp() {
		san_list = new List<List_Z>();
		List_Z l = new List_Z();
		l.name = 'foo';
		l.type = 'boolean';
		l.required = 'true';
		l.required_if = 'false';
		l.length = '25';
		l.disabled_if = 'false';
		san_list.add(l);
	}

	public static ps_fieldDescribeResp parse(String json) {
		json = ProfitstarsUtils.sanitizeJson(json);

		return (ps_fieldDescribeResp) System.JSON.deserialize(json, ps_fieldDescribeResp.class);
	}


}