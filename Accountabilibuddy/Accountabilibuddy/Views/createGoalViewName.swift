//
//  createGoalView1.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//

import SwiftUI

struct createGoalViewName: View {
   @State var goalName: String = ""
   @Binding var path: [GoalRoute]
   
   var body: some View {
      VStack{
         Text("What do you want to call this goal?")
         TextField(" ", text: $goalName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
         
         if (goalName != "") {
            Button("Next") {
                path.append(.askRecurring(goalName: goalName))
            }
         }
      }
   }
}

#Preview {
   createGoalViewName(
      goalName: "Test Non Binary Goal", path: .constant([])
    )
    .environmentObject(GoalViewModel())
}
