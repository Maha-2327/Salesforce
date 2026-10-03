public class StringListTest {
    public static List<String> generateStringList(Integer N) {
        List<String> result = new List<String>();

        for (Integer i = 0; i < N; i++) {
            result.add('Test ' + i);
        }

        return result;
    }
}