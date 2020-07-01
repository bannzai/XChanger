import Foundation

public protocol URLConvertible {
    var url: URL { get }
}

extension String: URLConvertible {
    public var url: URL { URL(string: self)! }
}

extension URL: URLConvertible {
    public var url: URL { self }
}
