import Foundation

internal struct Pool {
    internal static var shared = Pool()
    private init() { }
    internal var pool: [XChanger] = []
    
    internal func extract(request: URLRequest) -> XChanger? {
        pool.last { $0.request.canInit(request) }
    }
}
