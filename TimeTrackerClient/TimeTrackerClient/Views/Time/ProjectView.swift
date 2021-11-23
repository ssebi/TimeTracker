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
				Text("Date: \(timeslot.date.formatted(date: .abbreviated, time: .omitted))")
				Text("Start time: \(timeslot.details.start.formatted(date: .omitted, time: .standard))")
				Text("End time: \(timeslot.details.end.formatted(date: .omitted, time: .standard))")
			} else {
				DateLabel(text: "Date:", date: timeslot.date, style: .date)
				DateLabel(text: "Start time:", date: timeslot.details.start, style: .time)
				DateLabel(text: "End time:", date: timeslot.details.end, style: .time)
			}
			Text("Time period: \(timeslot.total)")
			Text("Task description: \(timeslot.details.description)")
		}.padding()
	}
}

struct Project_Previews: PreviewProvider {
	static var previews: some View {
		ProjectView(timeslot: TimeSlot(id: "", userId: "", clientId: 1, projectId: 1, date: Date(), details: TimeSlotDetails(start: Date(), end: Date(), description: ""), total: 1))
			.previewLayout(.sizeThatFits)
	}
}
