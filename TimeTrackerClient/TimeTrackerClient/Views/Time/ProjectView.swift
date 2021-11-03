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
				Text("Date: \(timeSlot.timeSlots.start.formatted(date: .omitted, time: .standard))")
				Text("Start time: \(timeSlot.timeSlots.start.formatted(date: .omitted, time: .standard))")
				Text("End time: \(timeSlot.timeSlots.end.formatted(date: .omitted, time: .standard))")
				Text("Time period: \(timeSlot.total)")
				Text("Task description: \(timeSlot.timeSlots.description)")
			}.padding()
		}
		.listStyle(InsetListStyle())
		.onAppear(perform: dataStore.fetchUsersTimeslots)
	}
}

struct Project_Previews: PreviewProvider {
	static var previews: some View {
		ProjectView()
			.environmentObject(DataStore())
	}
}
