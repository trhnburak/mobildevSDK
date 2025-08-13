//
//  mobildevSDKEvent.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import Foundation

public struct mobildevSDKEvent: Codable, Equatable, Sendable {
    public let id: UUID
    public let type: String
    public let name: String
    public let ts: TimeInterval
    public var attempts: Int

    public init(type: String, name: String, ts: TimeInterval = Date().timeIntervalSince1970, attempts: Int = 0) {
        self.id = UUID()
        self.type = type
        self.name = name
        self.ts = ts
        self.attempts = attempts
    }
}
