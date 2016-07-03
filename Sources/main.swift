import Vapor
import Foundation

struct Stuff {
  let index: Int = 9
  let title: String = "Foober"

  func toJSON() -> String {
    let dict = ["index": index, "title": title]
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
  return s.toJSON()
}

app.start()
