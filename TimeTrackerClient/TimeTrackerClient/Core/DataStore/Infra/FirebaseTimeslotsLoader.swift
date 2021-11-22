
import Firebase
import FirebaseFirestoreSwift

class FirebaseTimeslotsStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		Firestore.firestore().collection(Path.timeSlot)
			.whereField("userId", isEqualTo: userID)
			.addSnapshotListener { (querySnapshot, error) in
				if let querySnapshot = querySnapshot {
					let timeslots = querySnapshot.documents.compactMap { document -> FirebaseTimeSlot? in
						let decoder = JSONDecoder()
						decoder.dateDecodingStrategy = .iso8601
						if let data = try? JSONSerialization.data(withJSONObject: document.data()) {
							return try? decoder.decode(FirebaseTimeSlot.self, from: data)
						} else {
							return nil
						}
					}
					completion(.success(timeslots.toTimeSlot()))
				} else {
					completion(.failure(error!))
				}
			}
	}

}

private extension Sequence where Element == FirebaseTimeSlot {
	func toTimeSlot() -> [TimeSlot] {
		compactMap { firebaseTimeSlot -> TimeSlot? in
			TimeSlot(
				id: firebaseTimeSlot.id,
				userId: firebaseTimeSlot.userId,
				clientId: firebaseTimeSlot.clientId,
				projectId: firebaseTimeSlot.projectId,
				date: firebaseTimeSlot.date,
				details: firebaseTimeSlot.details.toTimeSlotDetail(),
				total: firebaseTimeSlot.total)
		}
	}
}

extension FirebaseTimeSlotDetails {
	func toTimeSlotDetail() -> TimeSlotDetails {
		TimeSlotDetails(start: start, end: end, description: description)
	}
}

fileprivate struct FirebaseTimeSlot: Codable {
	var id: String
	var userId: String
	var clientId: Int
	var projectId: Int
	var date: Date
	var details: FirebaseTimeSlotDetails
	var total: Int
}

private struct FirebaseTimeSlotDetails: Codable {
	var start: Date
	var end: Date
	var description: String
}
