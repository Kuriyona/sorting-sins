var n = args.Length > 0 ? int.Parse(args[0]) : 100;
var arr = Enumerable.Range(0, n).ToArray();
var rng = Random.Shared;

Array.Sort(arr, (a, b) => rng.Next(2) == 0 ? -1 : 1);

Console.WriteLine($"[{string.Join(", ", arr.Take(100))}]");
