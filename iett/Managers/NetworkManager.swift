//
//  NetworkManager.swift
//  iett
//
//  Created by Türker Kızılcık on 2.04.2024.
//

import Foundation

class NetworkManager {
    static let shared: NetworkManager = .init()

    func createSOAPRequest(soapRequest: SOAPRequest) -> URLRequest? {
        guard let url = URL(string: soapRequest.soapURL) else {
            print("Invalid URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = soapRequest.HTTPMethod
        request.httpBody = soapRequest.soapMessage.data(using: .utf8)

        for (key, value) in soapRequest.HTTPHeader {
            request.addValue(key, forHTTPHeaderField: value)
        }

        return request
    }


    func sendSOAPRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "com.example", code: -1, userInfo: ["description": "No data received"])))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
