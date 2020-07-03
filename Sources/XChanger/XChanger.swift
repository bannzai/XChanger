import Foundation
import ObjectiveC

public class XChanger {
    public static func register() {
        URLProtocol.registerClass(XChangeURLProtocol.self)

        guard let originalMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.default in exchange")
        }
        guard let swizzledMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.exchangerConfiguration)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.exchangerConfiguration in exchange")
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    public static func unregister() {
        URLProtocol.unregisterClass(XChangeURLProtocol.self)
        
        guard let originalMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.exchangerConfiguration)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.exchangerConfiguration in reverse")
        }
        guard let swizzledMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.default in reverse")
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    public static func exchange() -> RequestBuilder {
        XChanger()
    }
    
    internal var url: URL!
    internal var request: Request!
    internal var response: HTTPResponse!
    
    internal var urlRequest: URLRequest {
        var request = URLRequest.init(url: url)
        if let httpRequest = self.request as? HTTPRequest {
            request.httpMethod = httpRequest.httpMethod
        }
        return request
    }
}

extension XChanger: Builder {
    public func request(url: URLConvertible, http request: HTTPRequest) -> HTTPResponseBuilder {
        self.url = url.url
        self.request = request
        return self
    }
    
    public func response(response: HTTPResponse) -> XChanger {
        self.response = response
        return self
    }
    
    public func response(
        data: Data,
        statusCode: Int,
        httpVersion: String?,
        headers: [String: String]?,
        cacheStoragePolicy: URLCache.StoragePolicy
    ) -> XChanger {
        let httpURLResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headers
        )!
        self.response = HTTPResponse(
            success: (data: data, response: httpURLResponse),
            cacheStoragePolicty: cacheStoragePolicy
        )
        return self
    }
    
    public func response(error: ResponseError) -> EnableBuilder {
        self.response = HTTPResponse(error: error)
        return self
    }
    
    public func enable() {
        Pool.shared.pool.append(self)
    }
    
    public func disable() {
        _ = Pool.shared.pool.lastIndex(where: { $0 === self}).flatMap(Int.init).map { Pool.shared.pool.remove(at: $0) }
    }
}

extension URLSessionConfiguration {
    @objc class var exchangerConfiguration: URLSessionConfiguration {
        let config = self.exchangerConfiguration
        config.protocolClasses?.insert(XChangeURLProtocol.self, at: 0)
        return config
    }
}

