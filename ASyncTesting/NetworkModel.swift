//
//  NetworkModel.swift
//  ASyncTesting
//
//  Created by seokho on 2022/05/17.
//

import Foundation

class NetworkModel {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func say(_ text: String) async throws {
        guard !text.isEmpty,
              let url = URL(string: "http://127.0.0.1:8887") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(Message(id: UUID(),message: text, date: Date()))
        
        let (_, response) = try await urlSession.data(for: request, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.responded
        }
    }
    
    func sayWithCount(message: String) async throws {
        guard !message.isEmpty else { return }
        var countdown = 3
        
        let counter = AsyncStream<String> {
            
            defer { countdown -= 1 }
            
            switch countdown {
            case (1...):
                return "\(countdown)..."
            case 0:
                return message
            default:
                return nil
            }
        }
        
        for try await element in counter {
            try await self.say(element)
        }
    }
}

struct Message: Codable {
    var id: UUID
    var message: String
    var date: Date
}

enum NetworkError: Error {
    case responded
}
