//
//  String+Extension.swift
//  iett
//
//  Created by Türker Kızılcık on 2.04.2024.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }

    func localized(with parameters: String...) -> String {
        let localizedString = NSLocalizedString(self, comment: "")
        return String(format: localizedString, arguments: parameters)
    }

    func buildSOAPEnvelope() -> String {
        return """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
            <soapenv:Body>
                \(self)
            </soapenv:Body>
        </soapenv:Envelope>
        """
    }
}
