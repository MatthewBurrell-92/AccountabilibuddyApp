//
//  CreateBinaryGoal.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/24/26.
//

import SwiftUI

struct CreateBinaryGoal: View {
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
            
            TextField("make my bed, wake up early", text: $goalAction)
               .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
         }
         .font(.headline)
         .padding()
         .background(Color.white)
         .cornerRadius(8)
         .onAppear {
            print("Binary here")
         }
         
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
            print("binary")
            viewModel.addGoal(
               name: goalName,
               action: goalAction,
               frequency: goalFreq,
               type: .binary,
               email: []
            )
            print("Binary goal created")
            path = []
         }
         .buttonStyle(.borderedProminent)
      }
   }
}

#Preview {
    CreateBinaryGoal(
      goalName: "Test Binary Goal", path: .constant([])
    )
    .environmentObject(GoalViewModel())
}
