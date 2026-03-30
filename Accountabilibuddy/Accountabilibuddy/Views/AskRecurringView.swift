//
//  createGoalView2.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//

import SwiftUI

struct createGoalView2: View {
   @State var goalName: String = ""
   @State var showAlert: Bool = false
   
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
            NavigationLink(destination: createGoalView3(goalName: (goalName))) {
               Text("Yes")
                  .padding(.vertical, 4)
            }
            NavigationLink(destination: createGoalView3(goalName: (goalName))) {
               Text("No")
                  .padding(.vertical, 4)
            }
         }
      }
      
   }
}

#Preview {
   createGoalView2(goalName: "Test Goal")
}
