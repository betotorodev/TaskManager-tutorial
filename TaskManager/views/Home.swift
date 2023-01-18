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
  // return 24 hours in a day
  var hours: [Date] {
    let startOfDay = self.startOfDay(for: Date())
    var hours: [Date] = []
    for index in 0..<24 {
      if let date = self.date(byAdding: .hour, value: index, to: startOfDay) {
        hours.append(date)
      }
    }
    
    return hours
  }
  
  // returns current week in array format
  var currentWeek: [WeekDay] {
    guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else {
      return []
    }
    
    var week: [WeekDay] = []
    
    for index in 1..<7 {
      if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
        let weekDaySymbol: String = day.toString("EEEE")
        let isToday =  self.isDateInToday(day)
        week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
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
  @State private var task: [Task] = sampleTask
  @State private var addNewTask: Bool = false
  
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
          addNewTask.toggle()
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
    .background() {
      VStack(spacing: 0) {
        Color(.white)
        
        // gradiente opacity background
        Rectangle()
          .fill(.linearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .bottom))
          .frame(height: 20)
      }
      .ignoresSafeArea()
    }
  }
  
  // week row view
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
  
  // timeline View
  @ViewBuilder
  func TimelineView() -> some View {
    ScrollViewReader { proxy in
      let hours = Calendar.current.hours
      let midHour = hours[hours.count / 2]
      VStack {
        ForEach(hours, id: \.self) { hour in
          TimelineRowView(hour)
            .id(hour)
        }
      }
      .onAppear {
        proxy.scrollTo(midHour)
      }
    }
  }
  
  // timeline View row
  @ViewBuilder
  func TimelineRowView(_ date: Date) -> some View {
    HStack(alignment: .top) {
      Text(date.toString("h a"))
        .font(.caption)
        .frame(width: 45, alignment: .leading)
      
      // filtering data
      let calendar = Calendar.current
      let filteredTask = task.filter {
        if let hour = calendar.dateComponents([.hour], from: date).hour,
           let taskHour = calendar.dateComponents([.hour], from: $0.dateAdded).hour,
           hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay) {
          return true
        }
        return false
      }
      
      if filteredTask.isEmpty {
        Rectangle()
          .stroke(.gray.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
          .frame(height: 0.5)
          .offset(y: 10)
      } else {
        VStack {
          ForEach(filteredTask) { task in
            
            TaskRow(task)
          }
        }
      }
    }
    .hAlign(.leading)
    .padding(.vertical, 15)
  }
  
  // task view
  @ViewBuilder
  func TaskRow(_ task: Task) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(task.taskName.uppercased())
        .font(.subheadline)
        .foregroundColor(task.taskCatgory.color)
    }
    .hAlign(.leading)
    .padding(12)
    .background {
      ZStack(alignment: .leading) {
        Rectangle()
          .fill(task.taskCatgory.color)
          .frame(width: 4)
        
        Rectangle()
          .fill(task.taskCatgory.color.opacity(0.25))
      }
    }
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      TimelineView()
        .padding(15)
    }
    .safeAreaInset(edge: .top, spacing: 0) {
      HeaderView()
    }
    .fullScreenCover(isPresented: $addNewTask) {
      
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
