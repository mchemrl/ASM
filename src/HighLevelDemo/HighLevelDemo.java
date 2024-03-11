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

        String[] binaryNumbers = convertDecimalToBinary(numbers);
        binaryNumbers = bubbleSortAsc(binaryNumbers);

        int median = calculateMedian(binaryNumbers);

        System.out.println("median: " + median);
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
            int median1 = Integer.parseInt(sortedNumbers[middle - 1], 2);
            int median2 = Integer.parseInt(sortedNumbers[middle], 2);
            return (median1 + median2) / 2;
        } else {
            return Integer.parseInt(sortedNumbers[middle], 2);
        }
    }

    public static int[] resizeArray(int[] oldArray, int newSize) {
        int[] newArray = new int[newSize];
        System.arraycopy(oldArray, 0, newArray, 0, oldArray.length);
        return newArray;
    }
}