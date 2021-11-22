//
//  Project.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct ProjectView: View {
	@EnvironmentObject var dataStore: DataStore

	var body: some View {
		List(dataStore.userTimeslots) { timeSlot in
			VStack(alignment: .leading, spacing: 2) {
				Text("Project name: Project x")
					Text("Date: \(timeSlot.timeSlotDetail.start)")
					Text("Start time: \(timeSlot.timeSlotDetail.start)")
					Text("End time: \(timeSlot.timeSlotDetail.end)")

				Text("Time period: \(timeSlot.total)")
				Text("Task description: \(timeSlot.timeSlotDetail.description)")
			}.padding()
		}
		.listStyle(InsetListStyle())
		.onAppear(perform: getTimeslots)
	}

    func getTimeslots(){
        dataStore.getTimeSlots(clientId: 1, projectId: 1)
    }
}

struct Project_Previews: PreviewProvider {
	static var previews: some View {
		ProjectView()
			.environmentObject(DataStore())
	}
}
