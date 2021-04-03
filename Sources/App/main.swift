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
  var index: Int = 9
  var title: String = "Foober"
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
  } else {
    print("Ignoring request \(request.method) \(request.uri)")
    response.send("");
  }
}

try! server.start()




