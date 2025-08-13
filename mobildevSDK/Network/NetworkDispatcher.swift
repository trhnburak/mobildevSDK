//
//  NetworkDispatcher.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import Foundation

final class NetworkDispatcher {
    private var config: mobildevSDKConfig?
    private let retry: RetryPolicy
    private lazy var session: URLSession = URLSession(configuration: .ephemeral)

    init(retry: RetryPolicy) {
        self.retry = retry
    }

    func setup(config: mobildevSDKConfig) {
        self.config = config
    }

    func send(_ event: mobildevSDKEvent, completion: @escaping (Bool) -> Void) {
        guard let cfg = config else { completion(false); return }

        var req = URLRequest(url: cfg.endpoint)
        req.httpMethod = "POST"
        req.setValue(cfg.apiKey, forHTTPHeaderField: "X-API-Key")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.timeoutInterval = 10

        do { req.httpBody = try JSONEncoder().encode(event) } catch { completion(false); return }

        session.dataTask(with: req) { _, resp, err in
            if err != nil { completion(false); return }
            guard let http = resp as? HTTPURLResponse else { completion(false); return }
            completion((200..<300).contains(http.statusCode))
        }.resume()
    }

    func sendWithRetry(_ event: mobildevSDKEvent, queue: EventQueueManager) {
        send(event) { [weak self] success in
            guard let self else { return }
            if success {
                queue.markSuccess(event.id)
            } else {
                if self.retry.canRetry(event.attempts + 1) {
                    queue.markRetry(event.id)
                    let delay = self.retry.delay(for: event.attempts + 1)
                    DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + delay) {
                        queue.snapshot { items in
                            if let current = items.first(where: { $0.id == event.id }) {
                                self.sendWithRetry(current, queue: queue)
                            }
                        }
                    }
                }
            }
        }
    }
}
