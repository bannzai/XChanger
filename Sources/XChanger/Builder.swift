import Foundation

public protocol EnableBuilder {
    func enable()
    func disable()
}

public protocol RequestBuilder: EnableBuilder {
    func request(url: URLConvertible, http request: HTTP.Request) -> HTTPResponseBuilder
}

extension RequestBuilder {
    public func request(url: URLConvertible, http request: HTTP.Request = .init()) -> HTTPResponseBuilder {
        self.request(url: url, http: request)
    }
}

public protocol HTTPResponseBuilder: ResponseErrorBuilder, EnableBuilder {
    func response(response: HTTP.Response) -> XChanger
    func response(data: Data, statusCode: Int, httpVersion: String?, headers: [String: String]?, cacheStoragePolicy: URLCache.StoragePolicy) -> XChanger
}

extension HTTPResponseBuilder {
    func response(data: Data, statusCode: Int, httpVersion: String? = nil, headers: [String: String]? = nil, cacheStoragePolicy: URLCache.StoragePolicy = defaultCacheStoragePolicy) -> XChanger {
        response(data: data, statusCode: statusCode, httpVersion: httpVersion, headers: headers, cacheStoragePolicy: cacheStoragePolicy)
    }
}

public protocol ResponseErrorBuilder {
    func response(error: ResponseError) -> EnableBuilder
}

internal typealias Builder = RequestBuilder & HTTPResponseBuilder & ResponseErrorBuilder & EnableBuilder
