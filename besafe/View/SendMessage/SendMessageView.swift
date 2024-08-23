//
//  SendMessageView.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 21/08/24.
//

import SwiftUI
import MessageUI

struct SendMessageView: View {
    @StateObject private var viewModel = SendIMessViewModel()
    
    var body: some View {
        VStack {
            if viewModel.messageSent {
                Text("Message sent.")
            }
            Button("Tracking Location") {
                let recipients = ["+6281391667959", "+628116691020","+6281385334786"]
                let messageBody = "Test Send IMessage"
                viewModel.sendMessage(recipients: recipients, body: messageBody)
            }
        }
        .sheet(isPresented: $viewModel.isShowingMessageCompose) {
            MessageComposeViewControllerWrapper(viewModel: viewModel)
        }
    }
}

struct MessageComposeViewControllerWrapper: UIViewControllerRepresentable {
    @ObservedObject var viewModel: SendIMessViewModel

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        return viewModel.createMessageComposeViewController()
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
}

#Preview {
    SendMessageView()
}
