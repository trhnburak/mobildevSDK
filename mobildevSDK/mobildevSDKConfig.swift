//
//  mobildevSDKConfig.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import Foundation

public struct mobildevSDKConfig: Sendable {
    public let apiKey: String
    public let endpoint: URL
    public let flushAtLaunch: Bool
    public let maxRetryCount: Int

    public init(apiKey: String, endpoint: URL, flushAtLaunch: Bool = true, maxRetryCount: Int = 3) {
        self.apiKey = apiKey
        self.endpoint = endpoint
        self.flushAtLaunch = flushAtLaunch
        self.maxRetryCount = maxRetryCount
    }
}
