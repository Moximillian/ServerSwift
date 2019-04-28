//
//  HTTPServer.swift
//  ServerSwift
//
//  Created by Soini, Mox on 28/04/2019.
//

import Foundation
import NIO
import NIOHTTP1

typealias HTTPRequestResponseCallback = (HTTPRequestHead, HTTPServerResponse) -> Void

/// HTTP Server based on NIOHTTP1Server
struct HTTPServer {
  struct RequestResponsePair {
    let url: String
    let response: String
  }

  let host: String
  let port: Int
  let callback: HTTPRequestResponseCallback

  init(host: String = "::1", port: Int = 8080, callback: @escaping HTTPRequestResponseCallback) {
    self.host = host
    self.port = port
    self.callback = callback
  }

  func start() throws {
    /* setup for HTTP1 server */

    let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    let threadPool = NIOThreadPool(numberOfThreads: 6)
    threadPool.start()

    let bootstrap = ServerBootstrap(group: group)
      // Specify backlog and enable SO_REUSEADDR for the server itself
      .serverChannelOption(ChannelOptions.backlog, value: 256)
      .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

      // Set the handlers that are applied to the accepted Channels
      .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
          channel.pipeline.addHandler(HTTPHandler(callback: self.callback))
        }
      }

      // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
      .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
      .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
      .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)

    defer {
      try! group.syncShutdownGracefully()
      try! threadPool.syncShutdownGracefully()
    }

    let channel = try { () -> Channel in
      return try bootstrap.bind(host: host, port: port).wait()
      }()

    guard let localAddress = channel.localAddress else {
      fatalError("Address was unable to bind. Please check that the socket was not closed or that the address family was understood.")
    }
    print("Server started and listening on \(localAddress)")

    // This will never unblock as we don't close the ServerChannel
    try channel.closeFuture.wait()

    print("Server closed")
  }

}

/// Handler for HTTP requests
private final class HTTPHandler: ChannelInboundHandler {
  let callback: HTTPRequestResponseCallback

  init(callback: @escaping HTTPRequestResponseCallback) {
    self.callback = callback
  }

  typealias InboundIn = HTTPServerRequestPart
  func channelRead(context: ChannelHandlerContext, data: NIOAny) {
    let reqPart = unwrapInboundIn(data)

    switch reqPart {
    case .head(let header):
      print("\(Date()) – Method: \(header.method), URL: \(header.uri)")
      let response = HTTPServerResponse(channel: context.channel)
      callback(header, response)

    // ignore incoming content
    case .body, .end: break
    }
  }
}

/// HTTP Server response
final class HTTPServerResponse {
  public  var status         = HTTPResponseStatus.ok
  public  var headers        = HTTPHeaders()
  public  let channel        : Channel
  private var didWriteHeader = false
  private var didEnd         = false

  fileprivate init(channel: Channel) {
    self.channel = channel
  }

  func send(_ s: String) {
    flushHeader()
    var buffer = channel.allocator.buffer(capacity: s.lengthOfBytes(using: .utf8))
    buffer.writeString(s)
    let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
    _ = channel.writeAndFlush(part)
      .flatMapError(handleError)
      .map { self.end() }
  }

  /// Check whether we already wrote the response header.
  /// If not, do so.
  private func flushHeader() {
    guard !didWriteHeader else { return } // done already
    didWriteHeader = true
    let head = HTTPResponseHead(version: .init(major:1, minor:1),
                                status: status, headers: headers)
    let part = HTTPServerResponsePart.head(head)
    _ = channel.writeAndFlush(part)
      .flatMapError(handleError)
  }

  private func handleError(_ error: Error) -> EventLoopFuture<Void> {
    print("ERROR:", error)
    end()
    return channel.eventLoop.makeFailedFuture(error)
  }

  private func end() {
    guard !didEnd else { return }
    didEnd = true
    _ = channel.writeAndFlush(HTTPServerResponsePart.end(nil))
      .map { self.channel.close() }
  }
}
