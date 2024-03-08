
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public final class DataInput {

    private static void writeText(String wr) {
        if (wr == null)
            System.out.print("type in: ");
        else
            System.out.print(wr);
    }

    public static Long getLong() throws IOException {
        String s = getString();
        Long value = Long.valueOf(s);
        return value;
    }

    public static char getChar() throws IOException {
        String s = getString();
        return s.charAt(0);
    }

    public static String getString(String wr) {
        String s = "";
        String value = null;
        do {
            writeText(wr);
            try {
                s = getString();
                value = String.valueOf(s);
                return value;
            } catch (IOException e) {
                e.printStackTrace();
            }
        } while (value == null);
        return value;
    }

    public static String getWord(String wr) {
        String s = "";
        String value = null;
        do {
            writeText(wr);
            try {
                s = getString();
                value = String.valueOf(s);
                if (isWord(value)) {
                    return value;
                }
                else{
                    System.out.println("you can use letters only");
                    value = null;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        } while (value == null);
        return value;
    }

    private static boolean isWord(String s) {
        return s != null && s.matches("[a-zA-Z]+");
    }

    public static Integer getInt(String wr) {
        String s = "";
        Integer value = null;
        do {
            writeText(wr);
            try {
                s = getString();
                value = Integer.valueOf(s);
                return value;
            } catch (NumberFormatException e) {
                System.out.println("invalid number format. please enter a valid number.");
                value = null;
            } catch (IOException e) {
                e.printStackTrace();
            }
        } while (value == null);
        return value;
    }

    public static Double getDouble(String wr) {

        String s = "";
        Double value = null;
        do {
            writeText(wr);
            try {
                s = getString();
                value = Double.valueOf(s);
                return value;
            } catch (NumberFormatException e) {
                System.out.println("invalid number format. please enter a valid number.");
                value = null;
            } catch (IOException e) {
                e.printStackTrace();
            }
        } while (value == null);
        return value;
    }

    private static String getString() throws IOException {
        InputStreamReader isr = new InputStreamReader(System.in);
        BufferedReader br = new BufferedReader(isr);
        String s = br.readLine();
        return s;
    }

}
