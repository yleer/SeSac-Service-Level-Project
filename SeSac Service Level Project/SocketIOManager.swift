//
//  SocketManager.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/14.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    // 서버와 메시지를  주고 받기 위한 클래스
    var manger: SocketManager!
 
    // 클라이언트 소켓
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        let url = URL(string: "http://test.monocoding.com:35484")!
        
        manger = SocketManager(socketURL: url, config: [
            .log(true),
            .compress,
            .reconnects(true)
        ])
        
        socket = manger.defaultSocket // "/" 로 된 룸
//        socket = manger.socket(forNamespace: "/chat")
        
        // 소켓 연결 메서드
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            self.socket.emit("changesocketid", UserInfo.current.user!.uid)
        }
        
        socket.on(clientEvent: .disconnect) { data, ask in
            print("Disconnected", data, ask)
        }
        
        socket.onAny { event in
            print("socket working?")
        }
        
        //소켓 채팅듣는 메서드, sessac으로 날아온 데이터를 수신
        // 데이터 수신 -> 디코딩 -> 모델에 추가 -> UI upload
        socket.on("chat") { dataArray, ack in
            print("SESAC RECIEVED", dataArray,ack)

            let data = dataArray[0] as! NSDictionary
            let v = data["__v"] as! Int
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            let createdAt = data["createdAt"] as! String

            print("CHECK ", chat,createdAt)

            // 데이터 보내기 (소케에서 받아온 데이터 다른 vc로)
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["_id": id, "__v": v, "to": to, "from": from, "chat": chat, "createdAt": createdAt])
        }
    }
    
    
    func establishConnection() {
//        print("socket connect?")
        socket.connect()
//        print(socket.status, "socket status")
//
//        self.socket.on("connect") { ( dataArray, ack) -> Void in
//                print("connected to external server")
//        }
//        socket.on(clientEvent: .connect) { data, ack in
//            print("Socket is connected", data, ack)
//        }
//        self.socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
