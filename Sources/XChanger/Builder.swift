import Foundation

public protocol RequestBuilder {
    func request(http request: Request) -> HTTPResponseBuilder
}

public protocol HTTPResponseBuilder {
    func response(response: HTTPResponse) -> XChanger
    func response(data: Data, statusCode: Int, httpVersion: String?, headers: [String: String]?, cacheStoragePolicy: URLCache.StoragePolicy) -> XChanger
}

public protocol ResponseErrorBuilder {
    func response(error: ResponseErrorType) -> XChanger
}

internal typealias Builder = RequestBuilder & HTTPResponseBuilder & ResponseErrorBuilder
