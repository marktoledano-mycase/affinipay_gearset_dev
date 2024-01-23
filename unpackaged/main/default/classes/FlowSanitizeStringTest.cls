@isTest
public class FlowSanitizeStringTest {
    @isTest
    static void testGetRawString() {
        // Create test data
        FlowSanitizeString.RawString testRawString = new FlowSanitizeString.RawString();
        testRawString.theRawString = 'This is a test string!@#$%^&*()1234';

        // Add the test data to a list
        List<FlowSanitizeString.RawString> testRawStrings = new List<FlowSanitizeString.RawString>();
        testRawStrings.add(testRawString);

        // Call the invocable method
        Test.startTest();
        List<FlowSanitizeString.RawString> result = FlowSanitizeString.GetRawString(testRawStrings);
        Test.stopTest();

        // Assert the results
        System.assertEquals(1, result.size());
        System.assertEquals('Thisisateststring1234', result[0].theRawString);
        }
}