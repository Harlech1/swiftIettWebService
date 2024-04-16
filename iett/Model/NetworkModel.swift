//
//  NetworkModel.swift
//  iett
//
//  Created by Türker Kızılcık on 2.04.2024.
//

import Foundation

struct SOAPRequest {
    var soapURL: String
    var soapMessage: String
    var HTTPMethod: String
    var HTTPHeader: [String: String]
}

