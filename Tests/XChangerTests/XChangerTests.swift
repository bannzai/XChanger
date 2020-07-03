import XCTest
@testable import XChanger

struct Coder: Codable, Equatable {
    let id: Int
    let name: String
}

struct MyError: Error {
    
}
final class XChangerTests: XCTestCase {
    func testExample() {
        XCTContext.runActivity(named: "Success reponse pattern") { (_) in
            XChanger.register()
            defer { XChanger.unregister() }
            
            let expect = expectation(description: #function)
            let json = try! JSONEncoder().encode(Coder(id: 10, name: "bannzai"))
            XChanger.add(
                XChanger.exchange().request(url: "/").response(data: json, statusCode: 200)
            )
            
            let request = URLRequest(url: URL(string: "/")!)
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return XCTFail("Unexpected response type of HTTPURLResponse")
                }
                XCTAssertEqual(httpResponse.statusCode, 200)
                
                let decoded = try! JSONDecoder().decode(Coder.self, from: data!)
                XCTAssertEqual(decoded, Coder(id: 10, name: "bannzai"))
                
                expect.fulfill()
            }.resume()
            
            wait(for: [expect], timeout: 1)
        }
        XCTContext.runActivity(named: "Failure reponse pattern") { (_) in
            XChanger.register()
            defer { XChanger.unregister() }
            
            let expect = expectation(description: #function)
            XChanger.add(
                XChanger.exchange().request(url: "/").response(error: ResponseError(error: MyError()))
            )
            
            let request = URLRequest(url: URL(string: "/")!)
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: request) { data, response, error in
                if response != nil, data != nil {
                   XCTFail("Unexpected response and data are not nil")
                }
                
                XCTAssertTrue(error is MyError)
                expect.fulfill()
            }.resume()
            
            wait(for: [expect], timeout: 1)
        }
        XCTContext.runActivity(named: "Plural register pattern") { (_) in
            XChanger.register()
            defer { XChanger.unregister() }
            
            let json1 = try! JSONEncoder().encode(Coder(id: 10, name: "bannzai"))
            let json2 = try! JSONEncoder().encode(Coder(id: 100, name: "kingkong999"))
            XChanger.add(
                XChanger.exchange().request(url: "http://com.bannzai.xchanger/v1/user/10").response(data: json1, statusCode: 200),
                XChanger.exchange().request(url: "http://com.bannzai.xchanger/v1/user/100").response(data: json2, statusCode: 200)
            )
            
            bannzai: do {
                let expect = expectation(description: #function)
                let request = URLRequest(url: URL(string: "http://com.bannzai.xchanger/v1/user/10")!)
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        return XCTFail("Unexpected response type of HTTPURLResponse")
                    }
                    XCTAssertEqual(httpResponse.statusCode, 200)
                    
                    let decoded = try! JSONDecoder().decode(Coder.self, from: data!)
                    XCTAssertEqual(decoded, Coder(id: 10, name: "bannzai"))
                    
                    expect.fulfill()
                }.resume()
                wait(for: [expect], timeout: 1)
            }
            kingkong999: do {
                let expect = expectation(description: #function)
                let request = URLRequest(url: URL(string: "http://com.bannzai.xchanger/v1/user/100")!)
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        return XCTFail("Unexpected response type of HTTPURLResponse")
                    }
                    XCTAssertEqual(httpResponse.statusCode, 200)
                    
                    let decoded = try! JSONDecoder().decode(Coder.self, from: data!)
                    XCTAssertEqual(decoded, Coder(id: 100, name: "kingkong999"))
                    
                    expect.fulfill()
                }.resume()
                wait(for: [expect], timeout: 1)
            }
        }
    }
}
