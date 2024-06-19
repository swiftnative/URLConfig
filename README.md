# URLConfig

URLConfig its extension to standart network primitives like URLRequest, to be native in you networking.
It's provided flexible and friendly way to make http calls, with URLSession.

The main idea behinde to not use any wrappers and don't select in a separate layer all network. 
Insted, use native approach with straightforward configuration. 
What give full flexibility and increate [Locality-of-Behavior](https://htmx.org/essays/locality-of-behaviour/)

## Getting Started

Add the following dependency clause to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/swiftnative/URLConfig.git", from: "1.0.0")
]
```

The library depends on Apple's [Swift HTTP Types](https://github.com/apple/swift-http-types)


## Usage

```swift
// Create a request
var request = URLRequest.with(.myApi) {
    $0.method = .post
    $0.path = "/users/\(userID)/article"
    $0.body["title"] = "some-title"
    $0.body["text"] = "some-text"
}

// Do the call
let response = try await URLSession.shared.response(for: request)

// Handle result
guard response.status == .created else {
    // Handle error
}

let article: Article = response.decode()
```

You can find demo app inside and tests to get an idea of the usage
