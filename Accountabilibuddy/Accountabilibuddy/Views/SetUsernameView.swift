//
//  SetUsernameView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/18/26.
//
import SwiftUI

struct UsernameSetupView: View {
    @EnvironmentObject var settings: UserSettings
    @State private var input: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome! Set your username")
                .font(.title)
            
            TextField("Enter username", text: $input)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save") {
                if !input.isEmpty {
                    settings.username = input
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(input.isEmpty)
        }
        .padding()
    }
}

#Preview {
   UsernameSetupView()
}

