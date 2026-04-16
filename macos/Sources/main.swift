import Foundation

struct Track: Codable {
    let id: String
    let title: String
    let artist: String
    let duration: TimeInterval
}

final class MetadataCache {
    private let cacheURL: URL
    private var items: [String: Track] = [:]

    init(root: URL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!) {
        self.cacheURL = root.appendingPathComponent("Monochrome/metadata.json", isDirectory: false)
        load()
    }

    func upsert(_ track: Track) {
        items[track.id] = track
    }

    func fetch(id: String) -> Track? {
        items[id]
    }

    func save() {
        do {
            try FileManager.default.createDirectory(at: cacheURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            let data = try JSONEncoder().encode(items)
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            fputs("[Cache] Failed to persist metadata: \(error)\n", stderr)
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: cacheURL.path) else { return }
        do {
            let data = try Data(contentsOf: cacheURL)
            items = try JSONDecoder().decode([String: Track].self, from: data)
        } catch {
            fputs("[Cache] Failed to load metadata: \(error)\n", stderr)
        }
    }
}

final class DownloadManager {
    enum State: String {
        case queued
        case downloading
        case paused
        case complete
        case error
    }

    struct Item: Codable {
        var id: String
        var url: URL
        var state: State
        var bytesDownloaded: Int
        var totalBytes: Int
    }

    private(set) var queue: [Item] = []

    func enqueue(_ url: URL, id: String) {
        queue.append(Item(id: id, url: url, state: .queued, bytesDownloaded: 0, totalBytes: 0))
    }

    func markComplete(id: String) {
        guard let idx = queue.firstIndex(where: { $0.id == id }) else { return }
        queue[idx].state = .complete
    }
}

@main
enum MonochromeMacApp {
    static func main() {
        let cache = MetadataCache()
        let sample = Track(id: "demo-track", title: "Offline Ready", artist: "Monochrome", duration: 180)
        cache.upsert(sample)
        cache.save()

        let downloads = DownloadManager()
        downloads.enqueue(URL(string: "https://example.com/audio/demo.mp3")!, id: "demo-track")

        print("Monochrome macOS stub ready. Cached tracks: \(cache.fetch(id: sample.id) != nil), downloads queued: \(downloads.queue.count)")
    }
}
