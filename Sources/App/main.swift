import Foundation
import Vapor
//import Gloss

struct Stuff {
  let index: Int = 9
  let title: String = "Foober"

  func toJSON() -> String {
    let dict: [String: Any] = ["index": index, "title": title]
    do {
      let data = try JSONSerialization.data(withJSONObject: dict)
      return String(data: data, encoding: String.Encoding.utf8) ?? ""
    } catch let error {
      print("error converting to json: \(error)")
      return ""
    }
  }
}

let s = Stuff()

do {
  let drop = try Droplet()

  drop.get("/") { request in
    // print("REQUEST: ", request)
    return s.toJSON()
  }
  
  try drop.run()

} catch {
  print("ERROR: \(error)")
}
