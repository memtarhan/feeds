//
//  ModelData.swift
//  Feeds
//
//  Created by Mehmet Tarhan on 03/06/2023.
//

import Combine
import SwiftUI

class ModelData: ObservableObject {
    @Published var time: String = ""

    private var webSocketConnection: WebSocketConnection

    init() {
        webSocketConnection = WebSocketTaskConnection(url: URL(string: "ws://localhost:8000/time/")!)
        webSocketConnection.delegate = self

        webSocketConnection.connect()
    }

    func send(message: String) {
        webSocketConnection.send(text: message)
    }
}

extension ModelData: WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection) {
        print("Connected")
    }

    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        if let error = error {
            print("Disconnected with error:\(error)")
        } else {
            print("Disconnected normally")
        }
    }

    func onError(connection: WebSocketConnection, error: Error) {
        print("Connection error:\(error)")
    }

    func onMessage(connection: WebSocketConnection, text: String) {
        print("Text message: \(text)")
        DispatchQueue.main.async {
            self.time = text
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.webSocketConnection.send(text: "ping")
        }
    }

    func onMessage(connection: WebSocketConnection, data: Data) {
        print("Data message: \(data)")
    }
}
