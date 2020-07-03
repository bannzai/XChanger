import Foundation

internal func defaultRequestFilter(a: URLRequest, b: URLRequest) -> Bool {
    a.httpMethod == b.httpMethod && a.url == b.url
}
internal func defaultCanInit(with request: URLRequest) -> Bool { true }
internal func defaultCanonicalRequest(for request: URLRequest) -> URLRequest { request }
internal func defaultRequestIsCacheEquivalent(a: URLRequest, b: URLRequest) -> Bool { false }

public struct Request {
    internal let httpMethod: String?
    internal let filter: ((URLRequest, URLRequest) -> Bool)
    internal let canInit: ((URLRequest) -> Bool)
    internal let canonicalRequest: ((URLRequest) -> URLRequest)
    internal let requestIsCacheEquivalent: ((URLRequest, URLRequest) -> Bool)
    
    public init(
        httpMethod: String? = nil,
        filter: ((URLRequest, URLRequest) -> Bool)? = nil,
        canInit: ((URLRequest) -> Bool)? = nil,
        canonicalRequest: ((URLRequest) -> URLRequest)? = nil,
        requestIsCacheEquivalent: ((URLRequest, URLRequest) -> Bool)? = nil
    ) {
        self.httpMethod = httpMethod
        self.filter = filter ?? defaultRequestFilter(a:b:)
        self.canInit = canInit ?? defaultCanInit(with:)
        self.canonicalRequest = canonicalRequest ?? defaultCanonicalRequest(for:)
        self.requestIsCacheEquivalent = requestIsCacheEquivalent ?? defaultRequestIsCacheEquivalent(a:b:)
    }
}
