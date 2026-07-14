// Sorting Sins - Java

import java.util.*;

public class Main {
    public static void main(String[] args) {
        List<Integer> arr = new ArrayList<>();
        for (int i = 0; i < 100; i++) arr.add(i);
        Random rng = new Random();

        arr.sort((a, b) -> rng.nextInt(3) - 1);

        System.out.println(arr);
    }
}
