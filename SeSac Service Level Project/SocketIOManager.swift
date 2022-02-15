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
        
        let url = URL(string: "http://test.monocoding.com:35484/")!
        
        manger = SocketManager(socketURL: url, config: [
            .log(true),
            .compress
        ])
        
        socket = manger.defaultSocket // "/" 로 된 룸
        
        
        // 소켓 연결 메서드
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ask in
            print("Disconnected", data, ask)
        }
        
        //소켓 채팅듣는 메서드, sessac으로 날아온 데이터를 수신
        // 데이터 수신 -> 디코딩 -> 모델에 추가 -> UI upload
        socket.on("sesac") { dataArray, ack in
            print("SESAC RECIEVED", dataArray,ack)
            
            let data = dataArray[0] as! NSDictionary
            let chat = data["text"] as! String
            let name = data["name"] as! String
            let createdAt = data["createdAt"] as! String
            
            print("CHECK ", chat,name,createdAt)
            
            // 데이터 보내기 (소케에서 받아온 데이터 다른 vc로)
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["chat": chat, "name":name, "createdAt": createdAt])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
