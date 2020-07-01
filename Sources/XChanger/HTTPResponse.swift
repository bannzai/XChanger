import Foundation

public var defaultCacheStoragePolicy: URLCache.StoragePolicy = URLCache.StoragePolicy.allowed

public enum ResponseErrorType: Swift.Error {
    case client(Error)
    case server(Error, HTTPURLResponse)
}
public struct HTTPResponse {
    internal let result: Result<(data: Data, response: HTTPURLResponse), ResponseErrorType>
    internal let cacheStoragePolicty: URLCache.StoragePolicy
    
    public init(success: (data: Data, response: HTTPURLResponse), cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
        self.result = .success(success)
        self.cacheStoragePolicty = cacheStoragePolicty
    }
    public init(error: ResponseErrorType, cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
        self.result = .failure(error)
        self.cacheStoragePolicty = cacheStoragePolicty
    }
    public init(clientError error: Error, cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
        self.result = .failure(.client(error))
        self.cacheStoragePolicty = cacheStoragePolicty
    }
    public init(serverError error: (Error, HTTPURLResponse), cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
        self.result = .failure(.server(error.0, error.1))
        self.cacheStoragePolicty = cacheStoragePolicty
    }
    public init(result: Result<(data: Data, response: HTTPURLResponse), ResponseErrorType>, cacheStoragePolicty: URLCache.StoragePolicy = defaultCacheStoragePolicy) {
        self.result = result
        self.cacheStoragePolicty = cacheStoragePolicty
    }
}
