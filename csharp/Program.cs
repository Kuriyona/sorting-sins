var arr = Enumerable.Range(0, 100).ToArray();
var rng = Random.Shared;

Array.Sort(arr, (a, b) => rng.Next(2) == 0 ? -1 : 1);

Console.WriteLine($"[{string.Join(", ", arr)}]");
