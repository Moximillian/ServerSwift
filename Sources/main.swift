import Vapor

let app = Application()

app.get("/") { request in
  return "Hello, world!"
}

app.start()
