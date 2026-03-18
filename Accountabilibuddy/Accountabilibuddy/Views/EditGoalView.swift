//
//  EditGoalView.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/6/26.
//
import SwiftUI
import AppIntents

struct EditGoalView: View {
   @EnvironmentObject var viewModel: GoalViewModel
   @Binding var goal: Goal
   
   @State private var newEmail = ""
   
   var body: some View {
      Form {
         
         // MARK: Goal Name
         Section("Goal") {
            TextField("Goal name", text: $goal.name)
               .onChange(of: goal.name) { previousValue, newValue in
                   updateGoal()
               }
            
            TextField("Action", text: $goal.action)
                .onChange(of: goal.action) {
                    updateGoal()
                }
         }
         
         // MARK: Frequency
         Section("Frequency") {
            
            Picker("Frequency", selection: $goal.frequency) {
               ForEach(GoalUnitTime.allCases, id: \.self) { freq in
                  Text(freq.rawValue.capitalized)
                     .tag(freq)
               }
            }
            .pickerStyle(.segmented)
            .onChange(of: goal.frequency) {
                    updateGoal()
                }
         }
         
         // MARK: Goal Type
         Section("Goal Type") {
            
            Picker("Type", selection: goalTypeBinding) {
               Text("Binary").tag(GoalType.binary)
               Text("Quantitative").tag(GoalType.quantitative(value: 0, unit: ""))
            }
            .onChange(of: goal.type) { updateGoal() }
            
            if case .quantitative(let value, let unit) = goal.type {
               
               HStack {
                  Text("Value")
                  
                  TextField(
                     "Value",
                     value: quantitativeValueBinding,
                     format: .number
                  )
                  .keyboardType(.decimalPad)
                  .onChange(of: value) { updateGoal() }
               }
               
               TextField(
                  "Unit (pages, miles, etc.)",
                  text: quantitativeUnitBinding
               )
               .onChange(of: unit) { updateGoal() }
            }
         }
         
         // MARK: Email Notifications
         Section("Weekly Email Updates") {
            
            if case .emails(let emails) = goal.sendEmail {
               
               ForEach(emails, id: \.self) { email in
                  HStack {
                     Text(email)
                     
                     Spacer()
                     
                     Button(role: .destructive) {
                        removeEmail(email)
                     } label: {
                        Image(systemName: "trash")
                     }
                  }
               }
            }
            
            HStack {
               
               TextField("Add email", text: $newEmail)
                  .textInputAutocapitalization(.never)
                  .keyboardType(.emailAddress)
               
               Button("Add") {
                  addEmail()
               }
               .disabled(newEmail.isEmpty)
            }
         }
         HStack{
            Button("Save") {
            }
            
         }
      }
      .navigationTitle("Edit Goal")
      .navigationBarItems(trailing: Button("Save") {
          updateGoal()
      })
   }
}

// MARK: - Goal Updates via ViewModel
extension EditGoalView {
   
   private func updateGoal() {
      viewModel.updateGoal(goal: goal)
   }
   
   func addEmail() {
      guard newEmail.contains("@") else { return }
      
      switch goal.sendEmail {
      case .none:
         goal.sendEmail = .emails(emails: [newEmail])
      case .emails(var emails):
         emails.append(newEmail)
         goal.sendEmail = .emails(emails: emails)
      }
      
      newEmail = ""
      updateGoal()
   }
   
   func removeEmail(_ email: String) {
      if case .emails(var emails) = goal.sendEmail {
         emails.removeAll { $0 == email }
         goal.sendEmail = emails.isEmpty
         ? .none
         : .emails(emails: emails)
         updateGoal()
      }
   }
}

// MARK: - Bindings for Quantitative Type
extension EditGoalView {
   
   var goalTypeBinding: Binding<GoalType> {
      Binding(
         get: { goal.type },
         set: {
            goal.type = $0
            updateGoal()
         }
      )
   }
   
   var quantitativeValueBinding: Binding<Double> {
      Binding(
         get: {
            if case .quantitative(let value, _) = goal.type {
               return value
            }
            return 0
         },
         set: { newValue in
            if case .quantitative(_, let unit) = goal.type {
               goal.type = .quantitative(value: newValue, unit: unit)
               updateGoal()
            }
         }
      )
   }
   
   var quantitativeUnitBinding: Binding<String> {
      Binding(
         get: {
            if case .quantitative(_, let unit) = goal.type {
               return unit
            }
            return ""
         },
         set: { newUnit in
            if case .quantitative(let value, _) = goal.type {
               goal.type = .quantitative(value: value, unit: newUnit)
               updateGoal()
            }
         }
      )
   }
}

struct EditGoalView_PreviewWrapper: View {
   
   @State private var goal = Goal(
      id: UUID(),
      user: "Test",
      name: "Read BoM",
      action: "read",
      frequency: .week,
      progress: [],
      type: .quantitative(value: 15.0, unit: "pages"),
      sendEmail: .none
      //        type: .binary
   )
   
   var body: some View {
      EditGoalView(goal: $goal)
   }
}


#Preview {
   EditGoalView_PreviewWrapper()
}
