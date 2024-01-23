global class FlowSanitizeString {

    // replaceAll('[^a-zA-Z0-9\u4e00-\u9fa5]', ''))
    @InvocableMethod(label='Sanitize String')
    global static List<RawString> GetRawString(List<RawString> inputStrings) {      
        List<RawString> sanitizedStrings = new List<RawString>();
        
        for (RawString rStr : inputStrings) {
            if (rStr != null && rStr.theRawString != null) {
                rStr.theRawString = rStr.theRawString.replaceAll('[^a-zA-Z0-9\u4e00-\u9fa5]', '');
                sanitizedStrings.add(rStr);
            }
        }
        
        return sanitizedStrings;
    }
            
    global class RawString {
        @InvocableVariable(
            label = 'Raw String'
            description = 'Variable to store the Raw String'
        )
        global String theRawString;
    }     
}