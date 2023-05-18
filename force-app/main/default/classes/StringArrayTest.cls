public class StringArrayTest {
	public static list<string> generateStringArray(integer count) {
        list<string> testStrings = new list<string>();
        for(integer i=0; i<count; i++){
            testStrings.add('Test ' + i);
        }
        return testStrings;
    }
}