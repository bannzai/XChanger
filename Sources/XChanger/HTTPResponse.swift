import Foundation

public var defaultCacheStoragePolicy: URLCache.StoragePolicy = URLCache.StoragePolicy.allowed

public struct HTTPResponse {
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
