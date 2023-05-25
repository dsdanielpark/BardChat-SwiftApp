//
//  BardChatViewModel.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//

import Foundation

class BardChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    
    private let bard: Bard
    private var conversationID: String?
    
    init(token: String) {
        bard = Bard(token: token)
    }
    
    func startChat() {
        bard.getAnswer(inputText: "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.handleResponse(response)
            case .failure(let error):
                print("Error starting chat: \(error.localizedDescription)")
            }
        }
    }
    
    func sendMessage() {
        let inputText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !inputText.isEmpty else {
            return
        }
        
        addMessage(content: inputText, isSentByUser: true)
        
        bard.getAnswer(inputText: inputText) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.handleResponse(response)
            case .failure(let error):
                print("Error sending message: \(error.localizedDescription)")
            }
        }
        
        messageText = ""
    }
    
    func goBack() {
        // Handle navigation back
    }
    
    private func handleResponse(_ response: [String: Any]) {
        guard let conversationData = response["1"] as? [Any],
              let messageData = conversationData[conversationData.count - 1] as? [Any?],
              let messageContent = messageData[0] as? String else {
            print("Invalid response format")
            return
        }
        
        let isSentByUser = conversationID != nil
        
        addMessage(content: messageContent, isSentByUser: isSentByUser)
        
        if let newConversationID = response["3"] as? String {
            conversationID = newConversationID
        }
    }
    
    private func addMessage(content: String, isSentByUser: Bool) {
        let message = Message(content: content, isSentByUser: isSentByUser)
        messages.append(message)
    }
}

struct Message {
    let content: String
    let isSentByUser: Bool
}
