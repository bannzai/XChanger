import Foundation

internal func defaultCanInit(with request: URLRequest) -> Bool { true }
internal func defaultCanonicalRequest(for request: URLRequest) -> URLRequest { request }
internal func defaultRequestIsCacheEquivalent(a: URLRequest, b: URLRequest) -> Bool { false }

public var defaultCachedStoragePolicy: URLCache.StoragePolicy = URLCache.StoragePolicy.allowed
public func addExchangeURLXChanger(_ handlers: XChanger...) {
    Pool.shared.pool.append(contentsOf: handlers)
}

public struct XChanger {
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
    public struct Response {
        public enum ErrorType: Swift.Error {
            case client(Error)
            case server(Error, URLResponse)
        }
        
        internal let result: Result<(Data, URLResponse), ErrorType>
        internal let cachedStoragePolicty: URLCache.StoragePolicy
        public init(success: (Data, URLResponse), cachedStoragePolicty: URLCache.StoragePolicy = defaultCachedStoragePolicy) {
            self.result = .success(success)
            self.cachedStoragePolicty = cachedStoragePolicty
        }
        public init(error: ErrorType, cachedStoragePolicty: URLCache.StoragePolicy = defaultCachedStoragePolicy) {
            self.result = .failure(error)
            self.cachedStoragePolicty = cachedStoragePolicty
        }
        public init(clientError error: Error, cachedStoragePolicty: URLCache.StoragePolicy = defaultCachedStoragePolicy) {
            self.result = .failure(.client(error))
            self.cachedStoragePolicty = cachedStoragePolicty
        }
        public init(serverError error: (Error, URLResponse), cachedStoragePolicty: URLCache.StoragePolicy = defaultCachedStoragePolicy) {
            self.result = .failure(.server(error.0, error.1))
            self.cachedStoragePolicty = cachedStoragePolicty
        }
        public init(result: Result<(Data, URLResponse), ErrorType>, cachedStoragePolicty: URLCache.StoragePolicy = defaultCachedStoragePolicy) {
            self.result = result
            self.cachedStoragePolicty = cachedStoragePolicty
        }
    }
    
    public let request: Request
    public let response: Response
    public init(request: Request, response: Response) {
        self.request = request
        self.response = response
    }
}

