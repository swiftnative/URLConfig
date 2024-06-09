import Foundation

public extension URLSession.DataResponse {

  struct Config {
    public var decoder: JSONDecoder = JSONDecoder()
    public init () {}
  }

  func decode<T: Decodable>(
    config: Config = .init(),
    _ type: T.Type = T.self
  ) throws -> T {
    try config.decoder.decode(type, from: data)
  }
}
