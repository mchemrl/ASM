package HighLevelDemo;/*
Постановка задачі

Прочитати з stdin N десяткових чисел, розділених пробілом чи
новим рядком до появи EOF (макс довжина рядка 255 символів),
кількість чисел може до 10000.
Рядки розділяються АБО послідовністю байтів 0x0D та 0x0A (CR LF),
або одним символом - 0x0D чи 0x0A.
Кожне число це ціле десяткове знакове число, яке треба конвертувати в
бінарне представлення (word в доповнювальному коді).
Від'ємні числа починаються з '-'.
Увага: якщо число занадто велике за модулем для 16-бітного представлення
зі знаком, таке значення має бути представлене як максимально можливе (за модулем).
Відсортувати бінарні значення алгоритмом merge sort (asc)

OUTPUT:
Обчислити значення медіани та вивести десяткове в консоль як рядок (stdout)
Обчислити середнє значення та вивести десяткове в консоль як рядок (stdout)

Наприклад:
2 10 0
Результат:
2
4

 */

import java.util.ArrayList;
import java.util.Scanner;

public class HighLevelDemo {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("enter decimal numbers:");

        int[] numbers = new int[0];
        int index = 0;

        while (scanner.hasNext()) {
            if (scanner.hasNextInt()) {
                if (index == numbers.length) {
                    numbers = resizeArray(numbers, numbers.length + 1);
                }
                numbers[index] = scanner.nextInt();
                index++;
            } else {
                scanner.next();
            }

            //line breask (ctrl z or ctrl d)
            while (scanner.hasNext("[\\r\\n]+")) {
                scanner.next("[\\r\\n]+");
            }
        }
//FIX later when you press enter it throws exception

        String[] binaryNumbers = convertDecimalToBinary(numbers);
        binaryNumbers = bubbleSortAsc(binaryNumbers);

        System.out.println("sorted binary numbers:");
        for (String binaryNumber : binaryNumbers) {
            System.out.println(binaryNumber);
        }

        int median = calculateMedian(binaryNumbers);
        int average = calculateAverage(binaryNumbers);

        System.out.println("median: " + median);
        System.out.println("average: " + average);
    }


    public static String[] convertDecimalToBinary(int[] numbers) {
        String[] binaryNumbers = new String[numbers.length];

        for (int i = 0; i < numbers.length; i++) {
            if (numbers[i] == 0) {
                binaryNumbers[i] = "0";
                continue;
            }
            if (numbers[i] >= 32786 || numbers[i] <= -32786) {
                binaryNumbers[i] = "1000000000000000";
                continue;
            }

            boolean isNeg = false;
            if (numbers[i] < 0) {
                numbers[i] = -numbers[i];
                isNeg = true;
            }

            //convert numbers[i] to binary
            String binary = "";
            while (numbers[i] > 0) {
                int remainder = numbers[i] % 2;
                binary = remainder + binary;
                numbers[i] /= 2;
            }


            //format to 16bit length number
            String formattedNumber = "";
            for (int j = 0; j < 16 - binary.length(); j++) {
                formattedNumber += "0";
            }
            formattedNumber += binary;

            if (!isNeg) {
                binaryNumbers[i] = formattedNumber;
                continue;
            }

            //flip bits
            String reversedNumber = "";
            for (int j = 0; j < formattedNumber.length(); j++) {
                if (formattedNumber.charAt(j) == '1') {
                    reversedNumber += "0";
                } else {
                    reversedNumber += "1";
                }
            }

            //convert it to decimal and add 1
            int decimalValue = Integer.parseInt(reversedNumber, 2);
            decimalValue++;

            //convert it back to binary
            String binaryPlusOne = "";
            int numBits = 16; //number of bits needed
            while (numBits > 0) {
                binaryPlusOne = (decimalValue % 2) + binaryPlusOne;
                decimalValue /= 2;
                numBits--;
            }

            binaryNumbers[i] = binaryPlusOne;
        }

        return binaryNumbers;
    }

    public static String[] bubbleSortAsc(String[] binaryNumbers) {
        for (int i = 0; i < binaryNumbers.length; i++) {
            for (int j = 0; j < binaryNumbers.length - 1; j++) {
                if (binaryNumbers[j].compareTo(binaryNumbers[j + 1]) > 0) {
                    String temp = binaryNumbers[j];
                    binaryNumbers[j] = binaryNumbers[j + 1];
                    binaryNumbers[j + 1] = temp;
                }
            }
        }
        return binaryNumbers;
    }

    public static int calculateMedian(String[] sortedNumbers) {
        if (sortedNumbers.length == 0) {
            return 0;
        }
        int middle = sortedNumbers.length / 2;
        if (sortedNumbers.length % 2 == 0) {
            int median1 = convertBinaryToDecimal(sortedNumbers[middle - 1]);
            int median2 = convertBinaryToDecimal(sortedNumbers[middle]);
            return (median1 + median2) / 2;
        } else {
            return convertBinaryToDecimal(sortedNumbers[middle]);
        }
    }

    public static int calculateAverage(String[] sortedNumbers) {
        int sum = 0;
        for (String number : sortedNumbers) {
            sum += convertBinaryToDecimal(number);
        }
        return sum / sortedNumbers.length;
    }

    public static int convertBinaryToDecimal(String binary) {
        if (binary == null || binary.isEmpty()) {
            return 0;
        }

        boolean isNegative = binary.charAt(0) == '1';

        if (!isNegative) {
            return Integer.parseInt(binary, 2);
        } else {
            // two's complement using temp slot (2) and then replace it with 0 and 1 iykyk
            String invertedBinary = binary
                    .substring(1)
                    .replace('0', '2')
                    .replace('1', '0')
                    .replace('2', '1');

            int decimalValue = Integer.parseInt(invertedBinary, 2) + 1;

            return -decimalValue;
        }
    }
    public static int[] resizeArray(int[] oldArray, int newSize) {
        int[] newArray = new int[newSize];
        System.arraycopy(oldArray, 0, newArray, 0, oldArray.length);
        return newArray;
    }
}