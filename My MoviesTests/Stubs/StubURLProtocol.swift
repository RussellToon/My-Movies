//
//  StubURLProtocol.swift
//  My MoviesTests
//
//  Created by Russell Toon on 23/01/2021.
//

import Foundation


typealias StubResponse = (data: Data, status: Int)


class StubURLProtocol: URLProtocol {

    // Data to return for URLs
    static var testUrlResponses = [URL?: StubResponse]()

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let url = request.url {
            if let response = StubURLProtocol.testUrlResponses[url] {
                // Load immediately
                self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: url, statusCode: response.status, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: response.data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}


extension StubURLProtocol {

    static func urlSessionWithStub(url: URL?, response: StubResponse) -> URLSession {

        StubURLProtocol.testUrlResponses = [url: response]

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        let session = URLSession(configuration: config)
        return session
    }
}
