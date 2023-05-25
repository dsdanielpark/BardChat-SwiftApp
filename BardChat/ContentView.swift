//
//  ContentView.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//

import SwiftUI

struct ContentView: View {
    @State private var token: String = ""
    @State private var isChatStarted: Bool = false
    
    var body: some View {
        VStack {
            if !isChatStarted {
                Text("Enter Token:")
                    .font(.title)
                    .padding()
                
                TextField("Token", text: $token)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Next") {
                    isChatStarted = true
                }
                .font(.title)
                .padding()
            } else {
                BardChatView(token: token)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
