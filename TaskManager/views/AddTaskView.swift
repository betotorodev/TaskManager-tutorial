//
//  AddTaskView.swift
//  TaskManager
//
//  Created by Beto Toro on 12/01/23.
//

import SwiftUI

struct AddTaskView: View {
  // Callback
  var onAdd: (Task) -> ()
  // Properties
  @Environment(\.dismiss) private var dismiss
  @State private var taskName: String = ""
  @State private var taskDescription: String = ""
  @State private var taskDate: Date = .init()
  @State private var taskCategory: Category = .general
  
  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading, spacing: 10) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
            .foregroundColor(.white)
            .contentShape(Rectangle())
        }
        
        Text("Create a new task")
          .font(.title)
          .fontWeight(.light)
          .foregroundColor(.white)
          .padding(.vertical, 15)
        
        TitleView("Name")
        
        TextField("Make a new video", text: $taskName)
          .tint(.white)
          .padding(.top, 2)
        
        Divider()
          .background(.white)
        
        TitleView("Date")
          .padding(.top, 15)
        
        HStack(alignment: .bottom, spacing: 12) {
          HStack(spacing: 12) {
            Text(taskDate.toString("EEEE, DD, MMMM"))
            
            //Custom sate picker
            Image(systemName: "calendar")
              .font(.title)
              .foregroundColor(.white)
              .overlay {
                DatePicker("", selection: $taskDate, displayedComponents: [.date])
                  .blendMode(.destinationOver)
              }
          }
          .offset(y: -5)
          .overlay {
            Rectangle()
              .fill(.white.opacity(0.7))
              .frame(height: 1)
              .offset(y: 15)
          }
          
          HStack(spacing: 12) {
            Text(taskDate.toString("hh:mm a"))
            
            //Custom sate picker
            Image(systemName: "clock")
              .font(.title)
              .foregroundColor(.white)
              .overlay {
                DatePicker("", selection: $taskDate, displayedComponents: [.hourAndMinute])
                  .blendMode(.destinationOver)
              }
          }
          .offset(y: -2)
          .overlay {
            Rectangle()
              .fill(.white.opacity(0.7))
              .frame(height: 1)
              .offset(y: 16)
          }
        }
        .padding(.bottom, 15)
      }
        .environment(\.colorScheme, .dark)
        .hAlign(.leading)
        .padding(15)
        .background {
          taskCategory.color.ignoresSafeArea()
        }
      
      VStack(alignment: .leading, spacing: 10) {
        TitleView("Description", .gray)
        
        TextField("About your task", text: $taskDescription)
          .padding(.top, 2)
        
        Rectangle()
          .fill(.black.opacity(0.7))
          .frame(height: 1)
          
        TitleView("Category", .gray)
          .padding(.top, 15)
        
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 20), count: 3), spacing: 15) {
          
        }
      }
      .padding(15)
    }
    .vAlign(.top)
  }
  
  // Title view
  @ViewBuilder
  func TitleView(_ value: String, _ color: Color = .white.opacity(0.7)) -> some View {
    Text(value)
      .font(.headline)
      .fontWeight(.regular)
      .foregroundColor(color)
  }
}

struct AddTaskView_Previews: PreviewProvider {
  static var previews: some View {
    AddTaskView { task in
      
    }
  }
}
