import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

public class TestRunner {

    static int pass = 0;
    static int fail = 0;

    public static void main(String[] args) {
        System.out.println();
        System.out.println("========================================");
        System.out.println("  Temp Converter - Test Results");
        System.out.println("========================================");
        System.out.println();

        checkOutput("test1: 70°F converts correctly",  "70",  "21.1", "Expected output to contain 21.1. Check your formula: Celsius = 5.0/9 * (Fahrenheit - 32)");
        checkOutput("test2: 32°F converts correctly",  "32",  "0.0",  "Expected output to contain 0.0. Remember: 32°F is the freezing point, which is 0°C.");
        checkOutput("test3: 0°F converts correctly",   "0",   "17.7", "Expected output to contain 17.7. Make sure you're using double division, not integer division.");
        checkOutput("test4: 102°F converts correctly", "102", "38.8", "Expected output to contain 38.8. Check your formula.");
        checkOutput("test5: -32°F converts correctly", "-32", "35.5", "Expected output to contain 35.5. Make sure your program handles negative numbers.");

        System.out.println();
        System.out.println("========================================");
        System.out.printf("  Results: %d/%d tests passed%n", pass, pass + fail);
        System.out.println("========================================");
        System.out.println();

        if (fail > 0) System.exit(1);
    }

    /**
     * Pipes `input` into System.in, runs PA03.main(), captures stdout,
     * and checks whether the output contains `expected`.
     */
    static void checkOutput(String label, String input, String expected, String hint) {
        // Redirect System.in
        ByteArrayInputStream in = new ByteArrayInputStream((input + "\n").getBytes());
        System.setIn(in);

        // Capture System.out
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        PrintStream capture = new PrintStream(buffer);
        PrintStream original = System.out;
        System.setOut(capture);

        try {
            TempConverter.main(new String[]{});
        } catch (Exception e) {
            System.setOut(original);
            System.out.println("FAIL: " + label);
            System.out.println("   Program threw an exception: " + e.getMessage());
            fail++;
            return;
        }

        // Restore System.out
        System.setOut(original);
        String output = buffer.toString();

        if (output.contains(expected)) {
            System.out.println("PASS: " + label);
            pass++;
        } else {
            System.out.println("FAIL: " + label);
            System.out.println("   Hint: " + hint);
            System.out.println("   Your output was: " + output.trim());
            fail++;
        }
    }
}
