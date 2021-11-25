
import Foundation
import TimeTrackerClient

var uniqueTimeslots: [TimeSlot] {
	[
		uniqueTimeslot,
		uniqueTimeslot,
	]
}

var uniqueTimeslot: TimeSlot {
	TimeSlot(id: UUID().uuidString,
			 userId: UUID().uuidString,
			 clientId: Int.random(in: 0...100),
			 projectId: Int.random(in: 0...100),
			 date: Date(),
			 details:
				TimeSlotDetails(
					start: Date(),
					end: Date(),
					description: "some description"),
			 total: Int.random(in: 0...100))
}

let anyError = NSError(domain: "any error", code: 0)

let someUserID = UUID().uuidString
