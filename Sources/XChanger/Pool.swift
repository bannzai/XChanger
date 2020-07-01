import Foundation

internal struct Pool {
    internal static var shared = Pool()
    private init() { }
    internal var pool: [Handler] = []
    
    internal func extract(request: URLRequest) -> Handler? {
        pool.last { $0.request.canInit(request) }
    }
}
