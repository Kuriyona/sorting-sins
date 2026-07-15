// Sorting Sins - Java

import java.util.*;

public class Main {
    public static void main(String[] args) {
        int n = args.length > 0 ? Integer.parseInt(args[0]) : 100;
        List<Integer> arr = new ArrayList<>();
        for (int i = 0; i < n; i++) arr.add(i);
        Random rng = new Random();

        arr.sort((a, b) -> rng.nextInt(3) - 1);

        int limit = Math.min(100, arr.size());
        System.out.println(arr.subList(0, limit));
    }
}
