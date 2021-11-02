//
//  Project.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct ProjectView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var userData: DataStore
    
    var body: some View {
        List {
            ForEach(userData.userTimeslots, id: \.id){ timeSlot in
                VStack(alignment: .leading, spacing: 2){
                    Text("Time period: \(timeSlot.total)")
                    Text("Task description: \(timeSlot.timeSlots.description)")
                    Text("Start time: \(timeSlot.timeSlots.start)")
                    Text("End time: \(timeSlot.timeSlots.end)")
                }.padding()
            }
        }.listStyle(InsetListStyle())
    }
}

struct Project_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
