import Foundation

internal func defaultCanInit(with request: URLRequest) -> Bool { true }
internal func defaultCanonicalRequest(for request: URLRequest) -> URLRequest { request }
internal func defaultRequestIsCacheEquivalent(a: URLRequest, b: URLRequest) -> Bool { false }

public struct Request {
    internal let canInit: ((URLRequest) -> Bool)
    internal let canonicalRequest: ((URLRequest) -> URLRequest)
    internal let requestIsCacheEquivalent: ((URLRequest, URLRequest) -> Bool)
    
    public init(
        canInit: ((URLRequest) -> Bool)? = nil,
        canonicalRequest: ((URLRequest) -> URLRequest)? = nil,
        requestIsCacheEquivalent: ((URLRequest, URLRequest) -> Bool)? = nil
    ) {
        self.canInit = canInit ?? defaultCanInit(with:)
        self.canonicalRequest = canonicalRequest ?? defaultCanonicalRequest(for:)
        self.requestIsCacheEquivalent = requestIsCacheEquivalent ?? defaultRequestIsCacheEquivalent(a:b:)
    }
}
