# XChanger
XChange makes us enable to do mocking response with URL easily.

## Usage
Before start to register mocks, you need to call just one sentence, `XChanger.register()`, in some starting points like `@main`, `AppDelegate`, `SceneDelegate` or head of method in your unit test cases.
```swift
XChanger.register()
```

Then, passing response mock data with URL request as a key.
Here is the example for the URL `https://exmaple.com/v1/users/10`, and will return the 200 response with the body `{"id": 10, name:"bannzai"}`. 

```swift
struct User {
  var id: Int
  var name: String
}

let url = "https://exmaple.com/v1/users/10"
let json = try! JSONEncoder().encode(User(id: 10, name: "bannzai"))
XChanger.exchange().request(url: url).response(data: json, statusCode: 200).enable()
```

Finally, you can send URLRequest normaly, and you can see the response is what you defined.

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

## Installing
### Cocoapods

```ruby
pod 'XChanger', configuration: %w(Debug)
```

### Swift Package Manager
#### Xcode
Open File > Swift Packages > Add Package Dependency... and put Repository URL https://github.com/bannzai/XChanger.
This [document](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) will also help you.

#### Use as dependency

Add the following to your Package.swift file's dependencies:

```
.package(url: "https://github.com/bannzai/XChanger.git", from: "0.0.1")
```

## LICENSE
XChanger is released under the MIT license. See LICENSE for details.
