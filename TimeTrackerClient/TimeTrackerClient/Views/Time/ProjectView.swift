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
					Text("Date: \(timeSlot.details.start)")
					Text("Start time: \(timeSlot.details.start)")
					Text("End time: \(timeSlot.details.end)")

				Text("Time period: \(timeSlot.total)")
				Text("Task description: \(timeSlot.details.description)")
			}.padding()
		}
		.listStyle(InsetListStyle())
//		.onAppear(perform: dataStore.getTimeSlots)
	}
}

struct Project_Previews: PreviewProvider {
	static var previews: some View {
		ProjectView()
			.environmentObject(DataStore())
	}
}
