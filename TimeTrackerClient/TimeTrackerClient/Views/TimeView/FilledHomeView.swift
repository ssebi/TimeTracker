//
//  FilledHomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct FilledHomeView: View {
    @State var showView = false
    
    var body: some View {
            VStack{
                ProjectView()
                    .padding()
            }
            .navigationBarItems(
                  trailing: Button(action: {}, label: {
                      NavigationLink(destination: AddView()) {
                          Label("+", systemImage: "plus.rectangle.fill")
                              .foregroundColor(.cGreen)
                              .font(.system(size: 30))
                     }
                  }))
            .navigationTitle("Time Logged")
    }
}

struct FilledHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FilledHomeView()
    }
}
