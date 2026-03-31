//
//  CreateNonBinaryGoal.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//


import SwiftUI

struct CreateNonBinaryGoal: View {
   @EnvironmentObject var viewModel: GoalViewModel
   let goalName: String
   @Binding var path: [GoalRoute]

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
            //                    .padding()
            TextField("miles, pages, hours", text: $goalUnit)
               .textFieldStyle(RoundedBorderTextFieldStyle())
         }
         .font(.headline)
         .padding()
         .background(Color.white)
         .cornerRadius(8)
         
         HStack(spacing: 4) {
            Text("every")
            Picker("", selection: $goalFreq) {
               ForEach(GoalUnitTime.allCases, id: \.self) { freq in
                  Text(freq.rawValue)
                     .tag(freq)
               }
            }
            .pickerStyle(.menu)
            
         }
         .font(.headline)
         .padding()
         .background(Color.white)
         .cornerRadius(8)
         
         Button("Create Goal") {
            let goalType = GoalType.quantitative(value: goalValue ?? 0, unit: goalUnit)
            
            viewModel.addGoal(
               name: goalName,
               action: goalAction,
               frequency: goalFreq,
               type: goalType,
               email: []
            )
            print("Non binary goal created")
            path = []
         }
         .buttonStyle(.borderedProminent)
      }
   }
}


#Preview {
    CreateNonBinaryGoal(
      goalName: "Test Non Binary Goal", path: .constant([])
    )
    .environmentObject(GoalViewModel())
}
