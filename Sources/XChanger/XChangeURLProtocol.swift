import Foundation

internal class XChangeURLProtocol: URLProtocol {

    internal override class func canInit(with request: URLRequest) -> Bool {
        handler(for: request)?.request.canInit(request) ?? defaultCanInit(with: request)
    }
    
    internal override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        handler(for: request)?.request.canonicalRequest(request) ?? defaultCanonicalRequest(for: request)
    }
    
    internal override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        if let handler = handler(for: a) {
            return handler.request.requestIsCacheEquivalent(a, b)
        }
        if let handler = handler(for: b) {
            return handler.request.requestIsCacheEquivalent(a, b)
        }
        return defaultRequestIsCacheEquivalent(a: a, b: b)
    }
    
    internal override func startLoading() {
        guard let handler = XChangeURLProtocol.handler(for: request) else {
            fatalError("Unexpected condition about canInit == true but this handler is not exists")
        }
        defer {
            client?.urlProtocolDidFinishLoading(self)
        }
        switch handler.response.result {
        case .success(let response):
            client?.urlProtocol(self, didReceive: response.1, cacheStoragePolicy: handler.response.cacheStoragePolicty)
            client?.urlProtocol(self, didLoad: response.0)
        case .failure(let error):
            switch error {
            case .client(let error):
                client?.urlProtocol(self, didFailWithError: error)
            case .server(let error, let response):
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: handler.response.cacheStoragePolicty)
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
}

// MARK: - Internal
extension XChangeURLProtocol {
    class internal func handler(for request: URLRequest) -> XChanger? {
        Pool.shared.extract(request: request)
    }
}
