//
//  Models.swift
//  Accountabilibuddy
//
//  Created by Matthew Burrell on 3/4/26.
//

import Foundation

enum GoalType: Codable, Hashable {
   case binary
   case quantitative(value: Double, unit: String)
   case non_recurring(value: Double, unit: String, timeValue : Int)
}

//enum EmailProgress: Codable, Hashable {
//   case none
//   case emails(emails: [String])
//   //   mjbsoftwaretest@gmail.com
//}

enum GoalUnitTime: String, Codable, CaseIterable, Identifiable {
   case day
   case week
   case month
   case year
   
   var id: Self { self }
}

struct Progress: Codable, Identifiable, Hashable {
   var id: UUID = UUID()
   var goalID: UUID
   var date: Date
   var value: Double
}

struct Goal: Codable, Identifiable, Hashable {
   var id: UUID = UUID()
   var user: String
   var name: String
   var action: String
   //   var value: Double
   //   var unit: String
   var frequency: GoalUnitTime
   var progress: [Progress]
   var type: GoalType
   var sendEmail: [String]
   var active: Bool = true
   
   init(
      id: UUID = UUID(),
      user: String,
      name: String,
      action: String,
      frequency: GoalUnitTime,
      progress: [Progress],
      type: GoalType,
      sendEmail: [String],
      active: Bool = true
   ) {
      self.id = id
      self.user = user
      self.name = name
      self.action = action
      self.frequency = frequency
      self.progress = progress
      self.type = type
      self.sendEmail = sendEmail
      self.active = active
   }
}

extension Goal {
   var unitString: String? {
      guard case let .quantitative(_, unit) = type else { return nil }
      return unit
   }
   
   var valueDouble: Double? {
      guard case let .quantitative(value, _) = type else { return nil }
      return value
   }
   
   func setInactive() -> Goal {
      var updatedSelf = self
      updatedSelf.active = false
      return updatedSelf
   }
   
   func setActive() -> Goal {
      var updatedSelf = self
      updatedSelf.active = true
      return updatedSelf
   }
   
   mutating func addEmail(_ email: String) {
      guard email.contains("@") else { return }
      self.sendEmail.append(email)
      
   }
   
   mutating func removeEmail(_ email: String) {
      if self.sendEmail.isEmpty { return }
      self.sendEmail.removeAll { $0 == email }
   }
   
   func addProgress(_ progress: Progress) -> Goal {
      var updatedSelf = self
      updatedSelf.progress.append(progress)
      
      let totalValue = calculateTotalProgress(goal: updatedSelf)
      
      print("addProgress hit. totalValue: \(totalValue)")
      
      if case .non_recurring(let goalValue, _, _) = updatedSelf.type,
         totalValue >= goalValue {
         updatedSelf.active = false
         print("non_recurring set inactive")
      }
      
      return updatedSelf
   }
   
   func calculateTotalProgress(goal: Goal) -> Double {
      return goal.progress.reduce(0) { $0 + $1.value }
   }

   func calculateDailyTotalProgress(goal: Goal) -> Double {
      let calendar = Calendar.current
      var dailyProgress: Double = 0.0
      for progress in goal.progress.reversed() {
         if calendar.isDate(progress.date, inSameDayAs: Date()){
            dailyProgress += progress.value
         }
         else {
            return dailyProgress
         }
      }
      return dailyProgress
   }

   func calculateWeeklyTotalProgress(goal: Goal) -> Double {
      let calendar = Calendar.current
      var weeklyProgress: Double = 0.0
      
      // Get the start of the current week (Sunday)
      guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
         return 0.0
      }
      
      for progress in goal.progress.reversed() {
         if progress.date >= startOfWeek {
            weeklyProgress += progress.value
         } else {
            // Stop once we reach a progress outside this week
            break
         }
      }
      
      return weeklyProgress
   }

   func calculateMonthlyTotalProgress(goal: Goal) -> Double {
      let calendar = Calendar.current
      var monthlyProgress: Double = 0.0
      
      // Start of the current month
      guard let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start else {
         return 0.0
      }
      
      for progress in goal.progress.reversed() {
         if progress.date >= startOfMonth {
            monthlyProgress += progress.value
         } else {
            break
         }
      }
      
      return monthlyProgress
   }

   func calculateYearlyTotalProgress(goal: Goal) -> Double {
      let calendar = Calendar.current
      var yearlyProgress: Double = 0.0
      
      // Start of the current year
      guard let startOfYear = calendar.dateInterval(of: .year, for: Date())?.start else {
         return 0.0
      }
      
      for progress in goal.progress.reversed() {
         if progress.date >= startOfYear {
            yearlyProgress += progress.value
         } else {
            break
         }
      }
      
      return yearlyProgress
   }

   func checkForRecord(goal: Goal, timeUnit: GoalUnitTime) -> Bool {
      let calendar = Calendar.current
      
      if timeUnit == .day {
         if let lastProgress = goal.progress.last {
            if calendar.isDate(lastProgress.date, inSameDayAs: Date()) {
               return true
            }
         }
      }
      
      if timeUnit == .week {
         guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
            return false
         }
         for progress in goal.progress.reversed() {
            if progress.date >= startOfWeek {
               return true
            }
            else {
               return false
            }
         }
         
      }
      
      if timeUnit == .month {
         guard let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start else {
            return false
         }
         
         for progress in goal.progress.reversed() {
            if progress.date >= startOfMonth {
               return true
            } else {
               return false
            }
         }
      }
      
      if timeUnit == .year {
         guard let startOfYear = calendar.dateInterval(of: .year, for: Date())?.start else {
            return false
         }
         
         for progress in goal.progress.reversed() {
            if progress.date >= startOfYear {
               return true
            } else {
               return false
            }
         }
      }
      
      return false
   }

   func binaryMessageAndFlag(goal: Goal) -> (showButton: Bool, message: String) {
      switch goal.frequency {
      case .day:
         if checkForRecord(goal: goal, timeUnit: .day) { return (false, "You already recorded progress for today.") }
         else { return (true, "Did you \(goal.action) today?") }
      case .week:
         if checkForRecord(goal: goal, timeUnit: .week) { return (false, "You already recorded progress for this week.") }
         else { return (true, "Did you \(goal.action) this week?") }
      case .month:
         if checkForRecord(goal: goal, timeUnit: .month) { return (false, "You already recorded progress for this month.") }
         else { return (true, "Did you \(goal.action) this month?") }
      case .year:
         if checkForRecord(goal: goal, timeUnit: .year) { return (false, "You already recorded progress for this year.") }
         else { return (true, "Did you \(goal.action) this year?") }
      }
   }
}

extension GoalUnitTime {
   func displayName(for value: Int) -> String {
      value == 1 ? self.rawValue : self.rawValue + "s"
   }
}

enum GoalRoute: Hashable {
   case viewAllGoals
   case recordProgress(UUID)
   case editGoal(UUID)
   case nameInput
   case askRecurring(goalName: String)
   case createNonRecurring(goalName: String)
   case askBinary(goalName: String)
   case createNonBinary(goalName: String)
   case createBinary(goalName: String)
}


class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
    }
}
