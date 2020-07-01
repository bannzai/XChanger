import Foundation
import ObjectiveC

public func addExchangeURLXChanger(_ handlers: XChanger...) {
    Pool.shared.pool.append(contentsOf: handlers)
}

public struct XChanger {
    public static func exchange() {
        URLProtocol.registerClass(XChangeURLProtocol.self)

        guard let originalMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.default in exchange")
        }
        guard let swizzledMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.exchangerConfiguration)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.exchangerConfiguration in exchange")
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    public static func reverse() {
        URLProtocol.unregisterClass(XChangeURLProtocol.self)
        
        guard let originalMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.exchangerConfiguration)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.exchangerConfiguration in reverse")
        }
        guard let swizzledMethod = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default)) else {
            fatalError("Unexpected pattern for get method implementation of URLSessionConfiguration.default in reverse")
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    public let request: Request
    public let response: Response
    public init(request: Request, response: Response) {
        self.request = request
        self.response = response
    }
}

extension URLSessionConfiguration {
    @objc class var exchangerConfiguration: URLSessionConfiguration {
        let config = self.exchangerConfiguration
        config.protocolClasses?.insert(XChangeURLProtocol.self, at: 0)
        return config
    }
}
