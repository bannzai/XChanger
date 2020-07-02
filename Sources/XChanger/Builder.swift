import Foundation

public protocol RequestBuilder {
    func request(url: URLConvertible, http request: Request) -> HTTPResponseBuilder
}

extension RequestBuilder {
    public func request(url: URLConvertible, http request: Request = .init()) -> HTTPResponseBuilder {
        self.request(url: url, http: request)
    }
}

public protocol HTTPResponseBuilder: ResponseErrorBuilder {
    func response(response: HTTPResponse) -> XChanger
    func response(data: Data, statusCode: Int, httpVersion: String?, headers: [String: String]?, cacheStoragePolicy: URLCache.StoragePolicy) -> XChanger
}

extension HTTPResponseBuilder {
    func response(data: Data, statusCode: Int, httpVersion: String? = nil, headers: [String: String]? = nil, cacheStoragePolicy: URLCache.StoragePolicy = defaultCacheStoragePolicy) -> XChanger {
        response(data: data, statusCode: statusCode, httpVersion: httpVersion, headers: headers, cacheStoragePolicy: cacheStoragePolicy)
    }
}

public protocol ResponseErrorBuilder {
    func response(error: ResponseErrorType) -> XChanger
}

internal typealias Builder = RequestBuilder & HTTPResponseBuilder & ResponseErrorBuilder
