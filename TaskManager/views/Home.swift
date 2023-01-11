//
//  Home.swift
//  TaskManager
//
//  Created by Beto Toro on 10/01/23.
//

import SwiftUI

extension View {
  func hAlign(_ aligment: Alignment) -> some View {
    self
      .frame(maxWidth: .infinity, alignment: aligment)
  }
  
  func vAlign(_ aligment: Alignment) -> some View {
    self
      .frame(maxHeight: .infinity, alignment: aligment)
  }
}

extension Date {
  func toString(_ format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}

extension Calendar {
  var currentWeek: [WeekDay] {
    guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else {
      return []
    }
    
    var week: [WeekDay] = []
    
    for index in 1..<7 {
      if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
        let weekDaySymbol: String = day.toString("EEEE")
        let isToday =  self.isDateInToday(day)
        week.append(.init(string: weekDaySymbol, date: day))
      }
    }
    
    return week
  }
  
  struct WeekDay: Identifiable {
    var id: UUID = .init()
    var string: String
    var date: Date
    var isToday: Bool = false
  }
}

struct Home: View {
  @State private var currentDay: Date = .init()
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
    }
    .safeAreaInset(edge: .top, spacing: 0) {
      HeaderView()
    }
  }
  
  /// header view
  @ViewBuilder
  func HeaderView()-> some View {
    VStack {
      HStack {
        VStack(alignment: .leading, spacing: 6) {
          Text("Hoy")
            .font(.title)
          
          Text("Bienvenidos mi gente")
            .font(.headline)
        }
        .hAlign(.leading)
        
        Button {
          
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "plus")
            Text("Add task")
          }
          .padding(.vertical, 10)
          .padding(.horizontal, 15)
          .background {
            Capsule()
              .fill(Color(.blue).gradient)
          }
          .foregroundColor(.white)
        }
      }
      
      Text(Date().toString("MMM YYYY"))
        .hAlign(.leading)
        .padding(.top, 15)
      
      WeekRow()
    }
    .padding(15)
  }
  
  @ViewBuilder
  func WeekRow() -> some  View {
    HStack(spacing: 0) {
      ForEach(Calendar.current.currentWeek) { weekDay in
        let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
        VStack(spacing: 6) {
          Text(weekDay.string.prefix(3))
          Text(weekDay.date.toString("dd"))
            .font(status ? .title2 : .headline)
        }
        .foregroundColor(status ? Color(.blue) : .gray)
        .hAlign(.center)
        .contentShape(Rectangle())
        .onTapGesture {
          withAnimation(.easeInOut(duration: 0.3)) {
            currentDay = weekDay.date
          }
        }
      }
    }
    .padding(.vertical, 10)
    .padding(.horizontal, -25)
    .font(.callout)
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
