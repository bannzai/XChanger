import Foundation

public var defaultCacheStoragePolicy: URLCache.StoragePolicy = URLCache.StoragePolicy.allowed

internal protocol ResponseType {
    associatedtype Response: URLResponse
    var result: Result<(data: Data, response: Response), ResponseError> { get }
}
