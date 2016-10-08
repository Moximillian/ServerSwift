import Foundation
import Vapor
//import Gloss

struct Stuff {
  let index: Int = 9
  let title: String = "Foober"

  func toJSON() -> String {
    // Foundation on Linux is crap
    #if os(OSX) || os(iOS)
      let dict: [String: Any] = ["index": index, "title": title]
    #else
      let putput: [String: AnyObject] = ["index": NSNumber(value: index), "title": title.bridge() as NSString]
      let dict: NSDictionary = putput.bridge()
    #endif
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

let drop = Droplet()

drop.get("/") { request in
  // print("REQUEST: ", request)
  return s.toJSON()
}

drop.run()
