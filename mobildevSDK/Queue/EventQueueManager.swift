//
//  EventQueueManager.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import Foundation

final class EventQueueManager {
    private var items: [mobildevSDKEvent] = []
    private let storage = EventStorage()
    private let q = DispatchQueue(label: "mobildevSDK.queue.serial")

    func asyncLoad(_ completion: @escaping () -> Void) {
        storage.load { [weak self] loaded in
            guard let self else { return }
            q.async { [weak self] in
                self?.items = loaded
                completion()
            }
        }
    }

    func add(_ event: mobildevSDKEvent) {
        q.async { [weak self] in
            self?.items.append(event)
            self?.persist()
        }
    }

    func markSuccess(_ id: UUID) {
        q.async { [weak self] in
            guard let self else { return }
            self.items.removeAll { $0.id == id }
            self.persist()
        }
    }

    func markRetry(_ id: UUID) {
        q.async { [weak self] in
            guard let self else { return }
            if let idx = self.items.firstIndex(where: { $0.id == id }) {
                var e = self.items[idx]
                e.attempts += 1
                self.items[idx] = e
                self.persist()
            }
        }
    }

    func snapshot(_ block: @escaping ([mobildevSDKEvent]) -> Void) {
        q.async { [weak self] in
            block(self?.items ?? [])
        }
    }

    private func persist() {
        storage.saveAll(items)
    }
}
