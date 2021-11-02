//
//  FilledHomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct FilledHomeView: View {
    @EnvironmentObject var dataStore: DataStore
    @State var showView = false
    let startEndDate = StartEndDate(start: Date.now, end: Date.now)
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            ProjectView()
                .padding()
        }
        .navigationBarItems(
            leading: Button(action: {session.singOut()}, label: {
                Label("", systemImage: "power")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
            }),
            trailing:
                Button(action: {}, label: {
                    NavigationLink(destination:
                                    AddView()
                                    .environmentObject(startEndDate)
                    ) {
                        Label("+", systemImage: "plus.rectangle.fill")
                            .foregroundColor(.cGreen)
                            .font(.system(size: 30))
                    }
                })
        )
        .navigationTitle("Time Logged")
        .onAppear(perform: dataStore.fetchUsersTimeslots)
    }
}

struct FilledHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FilledHomeView()
    }
}
