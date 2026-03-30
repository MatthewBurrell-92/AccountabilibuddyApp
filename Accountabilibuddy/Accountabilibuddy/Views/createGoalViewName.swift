//
//  createGoalView1.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//

import SwiftUI

struct createGoalView1: View {
   @State var goalName: String = ""
   
   var body: some View {
      VStack{
         Text("What do you want to call this goal?")
         TextField(" ", text: $goalName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
         
         if (goalName != "") {
            NavigationLink(destination: createGoalView2(goalName: (goalName))) {
               Text("Next")
                  .padding(.vertical, 4)
            }
         }
      }
   }
}

#Preview {
   createGoalView1()
}
