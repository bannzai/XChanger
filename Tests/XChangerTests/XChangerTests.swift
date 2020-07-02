import XCTest
@testable import XChanger

struct Coder: Codable, Equatable {
    let id: Int
    let name: String
}
final class XChangerTests: XCTestCase {
    func testExample() {
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
                fatalError()
            }
            XCTAssertEqual(httpResponse.statusCode, 200)

            let decoded = try! JSONDecoder().decode(Coder.self, from: data!)
            XCTAssertEqual(decoded, Coder(id: 10, name: "bannzai"))
   
            expect.fulfill()
        }.resume()
        
        wait(for: [expect], timeout: 1)
    }
}
