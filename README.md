# XChanger
XChanger can exchange to behavior for URL request and response

## Usage
First, XChanger should call to start with `XChanger.register()`.
```swift
XChanger.register()
```

Second, define URL request and response.   
For example, It will return body of the response is `{"id": 10, name:"bannzai"}` and the response status code is 200, when you make a request to `https://exmaple.com/v1/users/10`.

Define exchange.
```swift
let url = "https://exmaple.com/v1/users/10"
let json = try! JSONEncoder().encode(User(id: 10, name: "bannzai"))
XChanger.exchange().request(url: url).response(data: json, statusCode: 200)
```

Request actually with URLSession.
```swift
let request = URLRequest(url: URL(string: "https://exmaple.com/v1/users/10")!)
let session = URLSession(configuration: URLSessionConfiguration.default)
session.dataTask(with: request) { data, response, error in
  guard let httpResponse = response as? HTTPURLResponse else {
      return fatalError("Unexpected response type of HTTPURLResponse")
  }
  print(httpResponse.statusCode) // 200
  
  let decoded = try! JSONDecoder().decode(User.self, from: data!)
  print(decoded) // User(id: 10, name: "bannzai")
}.resume()
```

## Install
### Cocoapods
Add the line below to Podfile and to exec $ pod install.

```ruby
pod 'XChanger', configuration: %w(Debug)
```

### Swift Package Manager
XChanger supported to install via Swift Package Manager. You can add Gedatsu on Xcode GUI. See [document](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).


## LICENSE
XChanger is released under the MIT license. See LICENSE for details.
