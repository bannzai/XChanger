import Foundation

internal protocol Request {
    var filter: RequestFilter { get }
}

public struct HTTPRequest: Request {
    internal let httpMethod: String?
    internal let filter: RequestFilter
    
    public init(
        httpMethod: String? = nil,
        filter: RequestFilter = .init()
    ) {
        self.httpMethod = httpMethod
        self.filter = filter
    }
}
