//
//  WatchConnect.swift
//  besafe
//
//  Created by Paulus Michael on 21/08/24.
//

import Combine
import WatchConnectivity

class WatchConnect: ObservableObject {
   var session: WCSession
   let delegate: WCSessionDelegate
   let subject1 = PassthroughSubject<String, Never>()
   let subject2 = PassthroughSubject<String, Never>()
   
   @Published private(set) var text1: String = ""
   @Published private(set) var text2: String = ""
   
   init(session: WCSession = .default) {
      self.delegate = WatchSession(textSubject1: subject1, textSubject2: subject2)
      self.session = session
      self.session.delegate = self.delegate
      self.session.activate()
      
      subject1
         .receive(on: DispatchQueue.main)
         .assign(to: &$text1)
      
      subject2
         .receive(on: DispatchQueue.main)
         .assign(to: &$text2)
   }
   
   func increment() {
      text1 = "I'm here"
      text2 = "You're there"
      session.sendMessage(["text1": text1, "text2": text2], replyHandler: nil) { error in
         print(error.localizedDescription)
      }
   }
   
   func decrement() {
      text1 = "I'm there"
      text2 = "You're here"
      session.sendMessage(["text1": text1, "text2": text2], replyHandler: nil) { error in
         print(error.localizedDescription)
      }
   }
   
   func ubah(_ text1: String, _ text2: String){
      self.text1 = text1
      self.text2 = text2
      
      session.sendMessage(["text1": text1, "text2": text2], replyHandler: nil) { error in
         print(error.localizedDescription)
      }
   }
}
