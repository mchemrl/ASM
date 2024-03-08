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

import java.util.Scanner;

public class HighLevelDemo {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("enter decimal numbers:");

        int[] numbers = new int[10000];
        int index = 0;

        while (scanner.hasNext() && index < 10000) {
            if (scanner.hasNextInt()) {
                numbers[index] = scanner.nextInt();
                index++;
            } else {
                scanner.next();
            }
        }

        scanner.close();
    }
}