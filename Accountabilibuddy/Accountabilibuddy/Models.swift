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

enum EmailProgress: Codable, Hashable {
   case none
   case emails(emails: [String])
   //   mjbsoftwaretest@gmail.com
}

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
   var sendEmail: EmailProgress
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
}

extension GoalUnitTime {
   func displayName(for value: Int) -> String {
      value == 1 ? self.rawValue : self.rawValue + "s"
   }
}

enum GoalRoute: Hashable {
   case recordProgress(UUID)
   case editGoal(UUID)
}
