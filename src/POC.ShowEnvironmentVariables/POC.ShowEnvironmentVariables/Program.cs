Console.WriteLine("Variables d'environnement :");

foreach (var kvp in Environment.GetEnvironmentVariables())
{
    var entry = (System.Collections.DictionaryEntry)kvp;
    Console.WriteLine($"{entry.Key} = {entry.Value}");
}

Console.WriteLine("Fin.");