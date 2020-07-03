import Foundation

internal class XChangeURLProtocol: URLProtocol {

    internal override class func canInit(with request: URLRequest) -> Bool {
        handler(for: request)?.requestFilter?.canInit(request) ?? defaultCanInit(with: request)
    }
    
    internal override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        handler(for: request)?.requestFilter?.canonicalRequest(request) ?? defaultCanonicalRequest(for: request)
    }
    
    internal override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        let defaultValue = defaultRequestIsCacheEquivalent(a: a, b: b)
        if let handler = handler(for: a) {
            return handler.requestFilter?.requestIsCacheEquivalent(a, b) ?? defaultValue
        }
        if let handler = handler(for: b) {
            return handler.requestFilter?.requestIsCacheEquivalent(a, b) ?? defaultValue
        }
        return defaultValue
    }
    
    internal override func startLoading() {
        guard let handler = XChangeURLProtocol.handler(for: request) else {
            fatalError("Unexpected condition about canInit == true but this handler is not exists")
        }
        defer {
            client?.urlProtocolDidFinishLoading(self)
        }
        guard let http = handler.http else {
            fatalError("Current support only http protool")
        }
        guard let response = http.response else {
            fatalError("HTTP Response is not allow nil")
        }
        switch response.result {
        case .success(let result):
            client?.urlProtocol(self, didReceive: result.1, cacheStoragePolicy: response.cacheStoragePolicty)
            client?.urlProtocol(self, didLoad: result.0)
        case .failure(let error):
            if let errorResponse = error.response {
                client?.urlProtocol(self, didReceive: errorResponse, cacheStoragePolicy: response.cacheStoragePolicty)
            }
            client?.urlProtocol(self, didFailWithError: error.error)
        }
    }
    
    override func stopLoading() {
        // None
    }
}

// MARK: - Internal
extension XChangeURLProtocol {
    class internal func handler(for request: URLRequest) -> XChanger? {
        Pool.shared.extract(request: request)
    }
}
