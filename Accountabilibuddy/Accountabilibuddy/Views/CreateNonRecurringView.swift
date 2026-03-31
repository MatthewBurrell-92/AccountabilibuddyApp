//
//  createGoalView3.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//

import SwiftUI

struct CreateNonRecurringView: View {
   @EnvironmentObject var viewModel: GoalViewModel
   let goalName: String
   @Binding var path: [GoalRoute]
   
   @State var showAlert: Bool = false
   
   @State var goalAction: String = ""
   @State var goalValue: Double?
   @State var goalUnit: String = ""
   @State var goalFreq: GoalUnitTime = .day
   @State var timeValue: Int?
   
   var body: some View {
      VStack{
         Text(goalName)
         HStack(spacing: 4) {
            Text("I want to")
            
            TextField("run, read, workout", text: $goalAction)
               .textFieldStyle(RoundedBorderTextFieldStyle())
         }
         .font(.headline)
         .padding()
         .background(Color.white)
         .cornerRadius(8)
         
         HStack(spacing: 4) {
            TextField("1, 3, 5", value: $goalValue, format: .number)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .frame(minWidth: 30, maxWidth: 80)
            
            TextField("miles, pages, hours", text: $goalUnit)
               .textFieldStyle(RoundedBorderTextFieldStyle())
         }
         .font(.headline)
         .padding()
         .background(Color.white)
         .cornerRadius(8)
         
         HStack(spacing: 4) {
            Text("within")
            
            TextField("1", value: $timeValue, format: .number)
               .textFieldStyle(RoundedBorderTextFieldStyle())
               .frame(minWidth: 30, maxWidth: 60)
            
            Picker("", selection: $goalFreq) {
               ForEach(GoalUnitTime.allCases, id: \.self) { freq in
                  Text(freq.displayName(for: timeValue ?? 0)).tag(freq)
               }
            }
            .pickerStyle(.menu)
         }
         .font(.headline)
         .padding()
         .background(Color.white)
         .cornerRadius(8)
         
         Button("Create Goal") {
            let goalType = GoalType.non_recurring(
               value: goalValue ?? 0,
               unit: goalUnit,
               timeValue: timeValue ?? 0
            )
            
            viewModel.addGoal(
               name: goalName,
               action: goalAction,
               frequency: goalFreq,
               type: goalType,
               email: []
            )
            print("Recurring goal created")
            path = []
         }
         .buttonStyle(.borderedProminent)
      }
   }
}


#Preview {
    CreateNonRecurringView(
      goalName: "Test Recurring Goal", path: .constant([])
    )
    .environmentObject(GoalViewModel())
}
