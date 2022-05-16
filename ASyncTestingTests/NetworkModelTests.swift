//
//  NetworkModelTests.swift
//  ASyncTestingTests
//
//  Created by seokho on 2022/05/17.
//

import Foundation
import XCTest
@testable import ASyncTesting

class NetworkModelTests: XCTestCase {
    
    let networkModel: NetworkModel = {
        let mockConfiguration = URLSessionConfiguration.default
        mockConfiguration.protocolClasses = [MockNetworkProtocol.self]
        
        return NetworkModel(urlSession: URLSession(configuration: mockConfiguration))
    }()
    
    func test_Say() async throws {
      try await networkModel.say("Hello, AsyncAwait")

      let request = try XCTUnwrap(MockNetworkProtocol.lastRequest)

      XCTAssertEqual(
        request.url?.absoluteString,
        "http://127.0.0.1:8887"
      )

      let httpBody = try XCTUnwrap(request.httpBody)
      let message = try XCTUnwrap(try? JSONDecoder()
        .decode(Message.self, from: httpBody))

      XCTAssertEqual(message.message, "Hello, AsyncAwait")
    }
    
//    func test_Countdown() async throws {
//        try await networkModel.sayWithCount(message: "Tada!")
//        try await TimeoutTask(seconds: 10) {
//          for await request in MockNetworkProtocol.requests {
//            print(request)
//          }
//        }
//        .value
//
//    }
    
//    func test_Countdown() async throws {
//        async let countdown: Void = networkModel.sayWithCount(message: "Tada!")
//        async let messages = TimeoutTask(seconds: 10) {
//          await MockNetworkProtocol.requests
//            .prefix(4)
//            .compactMap(\.httpBody)
//            .compactMap { data in
//              try? JSONDecoder()
//                .decode(Message.self, from: data).message
//            }
//            .reduce(into: []) { result, request in
//              result.append(request)
//            }
//        }
//        .value
//
//        let (messagesResult, _) = try await (messages, countdown)
//        
//        XCTAssertEqual(
//          ["3...", "2...", "1...", "Tada!"],
//          messagesResult
//        )
//
//    }
}
