//
//  MockNetworkProtocol.swift
//  ASyncTesting
//
//  Created by seokho on 2022/05/17.
//

import Foundation

class MockNetworkProtocol: URLProtocol {
    
    static var lastRequest: URLRequest? {
        didSet {
          if let request = lastRequest {
            continuation?.yield(request)
          }
        }
    }
    
    static private var continuation: AsyncStream<URLRequest>.Continuation?

    static var requests: AsyncStream<URLRequest> = {
      AsyncStream { continuation in
          MockNetworkProtocol.continuation = continuation
      }
    }()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = client,
              let url = request.url,
              let response = HTTPURLResponse(url: url,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil) else {
                  fatalError("Client or URL missing")
              }
        
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client.urlProtocolDidFinishLoading(self)
        
        guard let httpBodyStream = request.httpBodyStream else {
            fatalError("Unexpected test scenario")
        }
        
        var request = request
        request.httpBody = httpBodyStream.data
        Self.lastRequest = request
    }
    
    override func stopLoading() {}
}

extension InputStream {
    var data: Data {
        var data = Data()
        open()
        
        let maxLength = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
        while hasBytesAvailable {
            let read = read(buffer, maxLength: maxLength)
            guard read > 0 else { break }
            data.append(buffer, count: read)
        }
        
        buffer.deallocate()
        close()
        
        return data
    }
}
