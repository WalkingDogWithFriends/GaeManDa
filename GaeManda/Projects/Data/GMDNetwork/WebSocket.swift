//
//  WebSocket.swift
//  GMDNetwork
//
//  Created by 김영균 on 12/22/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol WebSocket {
	var delegate: WebSocketDelegate? { get set }
	
	func openWebSocket(with url: URL)
	func closeWebSocket()
	func sendData(_ data: Data)
	func sendText(_ string: String)
}

@objc public protocol WebSocketDelegate: AnyObject {
	/// 웹 소켓이 연결되었을 때 호출되는 메서드입니다.
	@objc optional func webSocket(webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?)
	
	/// 웹 소켓이 끊겼을 때 호출되는 메서드입니다.
	@objc optional func webSocket(
		webSocketTask: URLSessionWebSocketTask,
		didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
		reason: Data?
	)
	
	/// 메세지(데이터)를 받았을 때 호출되는 메서드입니다.
	@objc optional func webSocket(didReceiveData data: Data)
	
	/// 메세지(스트링)를 받았을 때 호출되는 메서드입니다.
	@objc optional func webSocket(didReceiveString string: String)
	
	/// 메세지를 보냈을 때 호출되는 메서드입니다.
	/// - Parameter error: 메세지를 보내는데 실패했을 때의 에러입니다.
	@objc optional func webSocket(didSendMessage error: Error?)
	
	/// 에러가 발생했을 때 호출되는 메서드입니다.
	@objc optional func webSocket(didReceiveError error: Error?)
}

public final class WebSocketProvider: NSObject {
	private var webSocketTask: URLSessionWebSocketTask?
	public weak var delegate: WebSocketDelegate?
	
	public override init() {
		super.init()
	}
	
	private func receive() {
		webSocketTask?.receive { [weak self] result in
			guard let self else { return }
			switch result {
			case let .success(message):
				switch message {
				case .data(let data): self.delegate?.webSocket?(didReceiveData: data)
				case .string(let text): self.delegate?.webSocket?(didReceiveString: text)
				@unknown default: break
				}
			
			case .failure(let error): 
				self.delegate?.webSocket?(didReceiveError: error)
			}
			self.receive()
		}
	}
}

extension WebSocketProvider: WebSocket {
	public func openWebSocket(with url: URL) {
		let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
		let webSocketTask = urlSession.webSocketTask(with: url)
		self.webSocketTask = webSocketTask
		webSocketTask.resume()
	}
	
	public func closeWebSocket() {
		webSocketTask?.cancel(with: .goingAway, reason: nil)
		webSocketTask = nil
	}
	
	public func sendData(_ data: Data) {
		guard let webSocketTask, let delegate else { return }
		let message = URLSessionWebSocketTask.Message.data(data)
		webSocketTask.send(message) { error in
			delegate.webSocket?(didSendMessage: error)
		}
	}
	public func sendText(_ string: String) {
		guard let webSocketTask, let delegate else { return }
		let message = URLSessionWebSocketTask.Message.string(string)
		webSocketTask.send(message) { error in
			delegate.webSocket?(didSendMessage: error)
		}
	}
}

extension WebSocketProvider: URLSessionWebSocketDelegate {
	public func urlSession(
		_ session: URLSession,
		webSocketTask: URLSessionWebSocketTask,
		didOpenWithProtocol protocol: String?
	) {
		receive()
		delegate?.webSocket?(webSocketTask: webSocketTask, didOpenWithProtocol: `protocol`)
	}
	
	public func urlSession(
		_ session: URLSession,
		webSocketTask: URLSessionWebSocketTask,
		didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
		reason: Data?
	) {
		delegate?.webSocket?(webSocketTask: webSocketTask, didCloseWith: closeCode, reason: reason)
	}
}
