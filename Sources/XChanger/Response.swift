import Foundation

public var defaultCachedStoragePolicy: URLCache.StoragePolicy = URLCache.StoragePolicy.allowed

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
