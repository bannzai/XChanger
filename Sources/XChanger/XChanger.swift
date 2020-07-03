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

    public static func add(_ handlers: XChanger...) {
        Pool.shared.pool.append(contentsOf: handlers)
    }
    public static func exchange() -> RequestBuilder {
        XChanger()
    }
    
    internal var url: URL!
    internal var request: Request!
    internal var response: HTTPResponse!
    
    internal var urlRequest: URLRequest {
        var request = URLRequest.init(url: url)
        request.httpMethod = self.request.httpMethod
        return request
    }
}

extension XChanger: Builder {
    public func request(url: URLConvertible, http request: Request) -> HTTPResponseBuilder {
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
    
    public func response(error: ResponseError) -> XChanger {
        self.response = HTTPResponse(error: error)
        return self
    }
}

extension URLSessionConfiguration {
    @objc class var exchangerConfiguration: URLSessionConfiguration {
        let config = self.exchangerConfiguration
        config.protocolClasses?.insert(XChangeURLProtocol.self, at: 0)
        return config
    }
}

