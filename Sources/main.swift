import Vapor

let app = Application()

app.get("/") { request in
  return "Hello swift!"
}

app.start()
