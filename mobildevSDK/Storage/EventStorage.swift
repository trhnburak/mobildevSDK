//
//  EventStorage.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import Foundation

final class EventStorage {
    private let fm = FileManager.default
    private let url: URL
    private let io = DispatchQueue(label: "mobildevSDK.storage.io", qos: .utility)

    init(filename: String = "mobildevSDK_events.json") {
        let base = fm.urls(for: .cachesDirectory, in: .userDomainMask).first!
        url = base.appendingPathComponent(filename)
    }

    func load(completion: @escaping ([mobildevSDKEvent]) -> Void) {
        io.async {
            guard let data = try? Data(contentsOf: self.url) else { completion([]); return }
            let items = (try? JSONDecoder().decode([mobildevSDKEvent].self, from: data)) ?? []
            completion(items)
        }
    }

    func saveAll(_ events: [mobildevSDKEvent]) {
        io.async {
            guard let data = try? JSONEncoder().encode(events) else { return }
            try? data.write(to: self.url, options: .atomic)
        }
    }
}
