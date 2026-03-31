//
//  AskBinaryView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//

import SwiftUI

struct AskBinaryView: View {
   let goalName: String
   @State var showAlert: Bool = false
   @Binding var path: [GoalRoute]
   
   var body: some View {
      VStack {
         Text(goalName)
         HStack {
            Text("Is this a binary goal?")
            
            Button {
               showAlert = true
            } label: {
               Image(systemName: "questionmark.circle")
                  .font(.title2)
            }
            .alert("Helpful Tip", isPresented: $showAlert) {
               Button("OK", role: .cancel) { }
            } message: {
               Text("A binary goal is something completed at one time, such as making your bed in the morning.")
            }
         }
         HStack {
            Button("Yes") {
                path.append(.createBinary(goalName: goalName))
            }
            Button("No") {
               path.append(.createNonBinary(goalName: goalName))
            }
         }
      }
   }
}

#Preview {
    AskBinaryView(
      goalName: "Test Ask Binary", path: .constant([])
    )
    .environmentObject(GoalViewModel())
}
