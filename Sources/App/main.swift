import Foundation
import Vapor

struct Stuff: Codable {
  let index: Int = 9
  let title: String = "Foober"
}

let s = Stuff()
let encoder = JSONEncoder()

do {
  let drop = try Droplet()

  drop.get("/") { request in
    // print("REQUEST: ", request)
    let data = try encoder.encode(s)
    return String(data: data, encoding: .utf8) ?? ""
  }
  
  try drop.run()

} catch {
  print("ERROR: \(error)")
}
