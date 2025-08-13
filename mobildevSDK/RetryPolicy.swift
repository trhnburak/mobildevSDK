//
//  RetryPolicy.swift
//  mobildevSDK
//
//  Created by Burak Turhan on 13.08.2025.
//

import Foundation

struct RetryPolicy: Sendable {
    let maxAttempts: Int

    func delay(for attempts: Int) -> TimeInterval {
        let capped = min(attempts, 6)
        return pow(2.0, Double(capped)) * 0.25
    }

    func canRetry(_ attempts: Int) -> Bool {
        attempts < maxAttempts
    }
}
