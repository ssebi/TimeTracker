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
        VStack {
            List(userData.allTimeSlots){ timeSlot in
                Text(timeSlot.timesSlots?.description as? String ?? "")
            }
        }.onAppear(perform: userData.get)
    }
}

struct Project_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
