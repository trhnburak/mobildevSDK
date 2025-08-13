//
//  mobildevSDKClient.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import Foundation

@objc(mobildevSDKClient)
public final class mobildevSDKClient: NSObject {
    @objc(shared) public static let shared = mobildevSDKClient()

    private var config: mobildevSDKConfig?
    private let queue = EventQueueManager()
    private lazy var dispatcher = NetworkDispatcher(retry: RetryPolicy(maxAttempts: config?.maxRetryCount ?? 3))

    private override init() {}

    public func initialize(config: mobildevSDKConfig) {
        self.config = config
        dispatcher.setup(config: config)
        queue.asyncLoad { [weak self] in
            guard let self else { return }
            if config.flushAtLaunch { self.flush() }
        }
    }

    @objc(trackClick:)
    public func trackClick(_ name: String) {
        track(type: "click", name: name)
        print("Track Click: \(name)")
    }

    @objc(trackScreen:)
    public func trackScreen(_ name: String) {
        track(type: "screen_view", name: name)
        print("Track Screen: \(name)")
    }

    private func track(type: String, name: String) {
        let event = mobildevSDKEvent(type: type, name: name)
        queue.add(event)
        dispatcher.sendWithRetry(event, queue: queue)
    }

    @objc(flush)
    public func flush() {
        queue.snapshot { [weak self] events in
            guard let self else { return }
            events.forEach { self.dispatcher.sendWithRetry($0, queue: self.queue) }
        }
    }
}
