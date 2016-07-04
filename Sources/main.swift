import Vapor
import Foundation

struct Stuff {
  let index: Int = 9
  let title: String = "Foober"

  func toJSON() -> String {
    // Foundation on Linux is crap
    #if os(OSX) || os(iOS)
      let dict = ["index": index, "title": title]
    #else
      let putput: [String: AnyObject] = ["index": NSNumber(value: index), "title": title.bridge() as NSString]
      let dict: NSDictionary = putput.bridge()
    #endif
    do {
      let data = try NSJSONSerialization.data(withJSONObject: dict)
      return String(data: data, encoding: NSUTF8StringEncoding) ?? ""
    } catch let error {
      print("error converting to json: \(error)")
      return ""
    }
  }
}

let s = Stuff()

let app = Application()

app.get("/") { request in
  // print("REQUEST: ", request)
  return s.toJSON()
}

app.start()
