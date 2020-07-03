import Foundation

public struct ResponseError: Swift.Error {
    let error: Error
    let response: URLResponse?
    public init(error: Error, response: URLResponse? = nil) {
        self.error = error
        self.response = response
    }
}

