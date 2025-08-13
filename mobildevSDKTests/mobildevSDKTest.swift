//
//  mobildevSDKdk.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import XCTest
@testable import mobildevSDK

final class mobildevSDKTests: XCTestCase {
    func testInitDoesNotBlockMainThread() {
        let cfg = mobildevSDKConfig(apiKey: "k", endpoint: URL(string: "https://example.com")!, flushAtLaunch: false)
        let start = CFAbsoluteTimeGetCurrent()
        mobildevSDKClient.shared.initialize(config: cfg)
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        XCTAssertLessThan(elapsed, 0.02)
    }
}
