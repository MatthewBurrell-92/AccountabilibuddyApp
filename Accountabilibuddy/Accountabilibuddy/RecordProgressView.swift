//
//  RecordProgressView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 2/3/26.
//


import SwiftUI

struct RecordProgressView: View {
   @Binding var goals: [Goal]
   @State var goalName: String = ""
//   @State var goals: [Goal] = []
   @Environment(\.dismiss) private var dismiss
    var body: some View {
       ZStack(alignment: .topLeading) {
//          Color.indigo
//              .ignoresSafeArea()
          
             
          
          VStack {
//             HStack { // Unnecessary
//                Button("Back") {
//                   dismiss()
//                }
//                .background((Color.white))
//                    Spacer()
//             }
//             .padding()

//              Text("What is the name of the goal?")
//                .background(Color.white)
//                
//             TextField(" ", text: $goalName)
//                 .textFieldStyle(RoundedBorderTextFieldStyle())
//                 .padding()
//             Button("Create Goal") {
//                 let newGoal = Goal(name: goalName)
//                 goals.append(newGoal)
//
//                 do {
//                     try saveGoals(goals)
//                     goalName = ""
//                 } catch {
//                     print("Failed to save goals:", error)
//                 }
//             }
//             .background(.black)
          }
       }
        
        .padding()

    }
       
   }



struct RecordProgressView_PreviewWrapper: View {
   // This is necessary because the #Preview
   // would not allow the goals parameter,
   // because it is out of scope. Or whatever.
    @State private var goals: [Goal] = []

    var body: some View {
        RecordProgressView(goals: $goals)
    }
}
   

#Preview {
   RecordProgressView_PreviewWrapper()
}
