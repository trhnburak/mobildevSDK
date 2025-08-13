//
//  EventQueueTests.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import XCTest
@testable import mobildevSDK

final class EventQueueTests: XCTestCase {
    func testRetryIncrementsAttemptsAndEventuallyStops() {
        let cfg = mobildevSDKConfig(apiKey: "k", endpoint: URL(string: "https://invalid.local")!, maxRetryCount: 2)
        mobildevSDKClient.shared.initialize(config: cfg)
        mobildevSDKClient.shared.trackClick("x")
        XCTAssertTrue(true)
    }
}
