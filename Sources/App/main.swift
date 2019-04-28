import Foundation

let defaultPort = 8080

func getPort() -> Int {
  let args = CommandLine.arguments
  guard
    args.count == 2,
    let port = Int(args[1]),
    port > 1023 else {
      print("Using default port \(defaultPort)")
      return defaultPort
  }
  return port
}

struct Stuff: Codable {
  let index: Int = 9
  let title: String = "Foober"
}

let s = Stuff()
let encoder = JSONEncoder()

func getBody() -> String {
  var body = ""
  do {
    let data = try encoder.encode(s)
    body = String(data: data, encoding: .utf8) ?? ""
  } catch {
    body = "ERROR: \(error)"
  }
  return body
}

let server = HTTPServer(port: getPort()) { request, response in

  if (request.uri == "/") {
    let responseData = getBody()
    response.send(responseData)
    print("Response: \(responseData)")
  }
}

try! server.start()




