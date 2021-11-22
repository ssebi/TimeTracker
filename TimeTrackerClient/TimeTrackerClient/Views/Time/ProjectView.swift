//
//  Project.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct ProjectView: View {
	let timeslot: TimeSlot

	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			Text("Project name: Project x")
			if #available(iOS 15.0, *) {
				Text("Date: \(Date().formatted(date: .abbreviated, time: .omitted))")
				Text("Start time: \(Date().formatted(date: .omitted, time: .standard))")
				Text("End time: \(Date().formatted(date: .omitted, time: .standard))")
			} else {
				DateLabel(text: "Date:", date: Date(), style: .date)
				DateLabel(text: "Start time:", date: Date(), style: .time)
				DateLabel(text: "End time:", date: Date(), style: .time)
			}
			Text("Time period: \(timeslot.total)")
			Text("Task description: \(timeslot.details.description)")
		}.padding()
	}
}

struct Project_Previews: PreviewProvider {
	static var previews: some View {
		ProjectView(timeslot: TimeSlot(id: "", userId: "", clientId: 1, projectId: 1, date: "2021-11-22T09:48:51Z", details: TimeSlotDetails(start: "2021-11-22T09:48:51Z", end: "2021-11-22T09:48:51Z", description: ""), total: 1))
			.environmentObject(DataStore())
	}
}
