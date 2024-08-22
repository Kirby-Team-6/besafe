//
//  SendIMessViewModel.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 21/08/24.
//

import Foundation
import MessageUI
import SwiftUI

class SendIMessViewModel: NSObject, ObservableObject, MFMessageComposeViewControllerDelegate {
    @Published var isShowingMessageCompose = false
    @Published var messageSent = false
    
    var messageModel: MessageModel?
    
    // Function to prepare and send the message
    func sendMessage(recipients: [String], body: String) {
        guard MFMessageComposeViewController.canSendText() else {
            print("Messaging not supported on this device")
            return
        }
        
        self.messageModel = MessageModel(recipients: recipients, body: body)
        isShowingMessageCompose = true
    }
    
    // Delegate function for MFMessageComposeViewController
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        messageSent = (result == .sent)
    }
    
    // Function to create the MFMessageComposeViewController instance
    func createMessageComposeViewController() -> MFMessageComposeViewController {
        let composeVC = MFMessageComposeViewController()
        composeVC.body = messageModel?.body
        composeVC.recipients = messageModel?.recipients
        composeVC.messageComposeDelegate = self
        return composeVC
    }
}
