using System.Text.Json;

namespace Monochrome.Windows;

internal record Track(string Id, string Title, string Artist, TimeSpan Duration);

internal sealed class MetadataCache
{
    private readonly string _path;
    private readonly Dictionary<string, Track> _items = new();

    public MetadataCache(string root)
    {
        Directory.CreateDirectory(root);
        _path = Path.Combine(root, "metadata.json");
        Load();
    }

    public void Upsert(Track track) => _items[track.Id] = track;

    public Track? Get(string id) => _items.TryGetValue(id, out var track) ? track : null;

    public void Save()
    {
        var json = JsonSerializer.Serialize(_items, new JsonSerializerOptions { WriteIndented = true });
        File.WriteAllText(_path, json);
    }

    private void Load()
    {
        if (!File.Exists(_path)) return;
        var json = File.ReadAllText(_path);
        var loaded = JsonSerializer.Deserialize<Dictionary<string, Track>>(json);
        if (loaded is null) return;
        foreach (var kvp in loaded) _items[kvp.Key] = kvp.Value;
    }
}

internal sealed class DownloadQueue
{
    public enum State { Queued, Downloading, Paused, Complete, Error }

    public sealed record Item(string Id, Uri Url, State Status, long BytesDownloaded, long TotalBytes);

    private readonly List<Item> _items = new();

    public void Enqueue(Uri url, string id) => _items.Add(new Item(id, url, State.Queued, 0, 0));

    public IReadOnlyList<Item> Items => _items;
}

internal static class Program
{
    private static void Main()
    {
        var cacheRoot = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "MonochromeWin");
        var cache = new MetadataCache(cacheRoot);
        var track = new Track("demo-track", "Offline Ready", "Monochrome", TimeSpan.FromMinutes(3));
        cache.Upsert(track);
        cache.Save();

        var queue = new DownloadQueue();
        queue.Enqueue(new Uri("https://example.com/audio/demo.mp3"), track.Id);

        Console.WriteLine("Monochrome Windows stub ready");
        Console.WriteLine($"Cached track: {cache.Get(track.Id)?.Title ?? "missing"}");
        Console.WriteLine($"Downloads queued: {queue.Items.Count}");
    }
}
