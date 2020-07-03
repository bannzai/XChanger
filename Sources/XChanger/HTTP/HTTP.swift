import Foundation

// MARK: - NameSpace
public struct HTTP {
    internal var request: Request?
    internal var response: Response?
}

// MARK: - Request
extension HTTP {
    public struct Request: RequestType {
        internal let httpMethod: String?
        internal let filter: RequestFilter
        
        public init(
            httpMethod: String? = nil,
            filter: RequestFilter = .init()
        ) {
            self.httpMethod = httpMethod
            self.filter = filter
        }
    }
}

// MARK: - Response
extension HTTP {
    public struct Response: ResponseType {
        typealias Response = HTTPURLResponse
        
        internal let result: Result<(data: Data, response: HTTPURLResponse), ResponseError>
        internal let cacheStoragePolicty: URLCache.StoragePolicy
        
        public init(success: (data: Data, response: HTTPURLResponse), cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
            self.result = .success(success)
            self.cacheStoragePolicty = cacheStoragePolicty
        }
        public init(error: ResponseError, cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
            self.result = .failure(error)
            self.cacheStoragePolicty = cacheStoragePolicty
        }
        public init(error: Error, response: URLResponse? = nil, cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
            self.result = .failure(ResponseError(error: error, response: response))
            self.cacheStoragePolicty = cacheStoragePolicty
        }
        public init(result: Result<(data: Data, response: HTTPURLResponse), ResponseError>, cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
            self.result = result
            self.cacheStoragePolicty = cacheStoragePolicty
        }
    }
}
