//
//  createGoalView2.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//

import SwiftUI

struct AskRecurringView: View {
   let goalName: String
   @State var showAlert: Bool = false
   @Binding var path: [GoalRoute]
      
   var body: some View {
      VStack{
         Text(goalName)
         HStack {
            Text("Is this a recurring goal?")
            Button {
               showAlert = true
            } label: {
               Image(systemName: "questionmark.circle")
                  .font(.title2) // adjust size
            }
            .alert("Helpful Tip", isPresented: $showAlert) {
               Button("OK", role: .cancel) { }
            } message: {
               Text("A recurring goal is something that is completed everyday, week or month. A non-recurring goal is something that is completed only once over a specified period of time. An example of a non-recurring goal is to lose 20 pounds over six months.")
            }
         }
         
         HStack {
            
            Button("Yes") {
                path.append(.askBinary(goalName: goalName))
            }
            
            Button("No") {
                path.append(.createNonRecurring(goalName: goalName))
               print("NOOOOO")
            }
            
            
         }
      }
   }
}


#Preview {
   AskRecurringView(
      goalName: "Test Ask Recurring", path: .constant([])
   )
   .environmentObject(GoalViewModel())
}
