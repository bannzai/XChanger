import Foundation

internal func defaultRequestFilter(a: URLRequest, b: URLRequest) -> Bool {
    a.httpMethod == b.httpMethod && a.url?.host == b.url?.host && a.url?.path == b.url?.path
}

public struct RequestFilter {
    internal let filter: ((URLRequest, URLRequest) -> Bool)
    internal let canInit: ((URLRequest) -> Bool)?
    internal let canonicalRequest: ((URLRequest) -> URLRequest)?
    internal let requestIsCacheEquivalent: ((URLRequest, URLRequest) -> Bool)?
    
    public init(
        filter: ((URLRequest, URLRequest) -> Bool)? = nil,
        canInit: ((URLRequest) -> Bool)? = nil,
        canonicalRequest: ((URLRequest) -> URLRequest)? = nil,
        requestIsCacheEquivalent: ((URLRequest, URLRequest) -> Bool)? = nil
    ) {
        self.filter = filter ?? defaultRequestFilter(a:b:)
        self.canInit = canInit
        self.canonicalRequest = canonicalRequest
        self.requestIsCacheEquivalent = requestIsCacheEquivalent
    }
    
    public func callAsFunction(_ a: URLRequest, _ b: URLRequest) -> Bool {
        filter(a, b)
    }
}


