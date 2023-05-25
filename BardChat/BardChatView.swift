//
//  BardChatView.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//
import SwiftUI

struct BardChatView: View {
    @ObservedObject var viewModel: BardChatViewModel
    
    var body: some View {
        VStack {
            // 대화 메시지 목록 표시
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        MessageView(message: message)
                    }
                }
                .padding()
            }
            
            // 메시지 입력 및 전송 버튼
            HStack {
                TextField("메시지를 입력하세요", text: $viewModel.messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Text("전송")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.trailing)
            }
        }
        .navigationTitle("Chat")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            viewModel.goBack()
        }) {
            Image(systemName: "arrow.left")
        })
        .onAppear {
            viewModel.startChat()
        }
    }
}

struct MessageView: View {
    var message: Message
    
    var body: some View {
        VStack(alignment: .leading) {
            if message.isSentByUser {
                Text("User:")
                    .font(.headline)
                    .foregroundColor(.blue)
            } else {
                Text("Bard:")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            Text(message.content)
                .padding(8)
                .background(message.isSentByUser ? Color.blue.opacity(0.2) : Color.red.opacity(0.2))
                .cornerRadius(10)
        }
    }
}
