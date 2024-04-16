//
//  StringManager.swift
//  iett
//
//  Created by Türker Kızılcık on 3.04.2024.
//

import Foundation

class StringManager {
    static let shared: StringManager = .init()

    func extractJSONDataFromResponse(data: Data) -> Data? {
        guard
            let responseString = String(data: data, encoding: .utf8),
            let startIndex = responseString.range(of: "[{")?.lowerBound,
            let endIndex = responseString.range(of: "}]")?.upperBound
        else { return nil }

        let jsonString = responseString[startIndex..<endIndex]
        return jsonString.data(using: .utf8)
    }
}
