Console.WriteLine("----");
Console.WriteLine("Begin");
Console.WriteLine("----");
Console.WriteLine();
Console.WriteLine("---------------------------");
Console.WriteLine("Args");
Console.WriteLine("---------------------------");
Console.WriteLine();
args.ToList().ForEach(arg => Console.WriteLine($"Arg: {arg}"));
Console.WriteLine();
Console.WriteLine("---------------------------");
Console.WriteLine("Variables d'environnement :");
Console.WriteLine("---------------------------");
Console.WriteLine();
foreach (var kvp in Environment.GetEnvironmentVariables())
{
    var entry = (System.Collections.DictionaryEntry)kvp;
    Console.WriteLine($"{entry.Key} = {entry.Value}");
}
Console.WriteLine();
Console.WriteLine("---");
Console.WriteLine("End");
Console.WriteLine("---");