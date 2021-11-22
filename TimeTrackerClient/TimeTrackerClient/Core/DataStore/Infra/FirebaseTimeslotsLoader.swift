
import Firebase
import FirebaseFirestoreSwift

class FirebaseTimeslotsStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		Firestore.firestore().collection(Path.timeSlot)
			.whereField("userId", isEqualTo: userID)
			.addSnapshotListener { (querySnapshot, error) in
				if let querySnapshot = querySnapshot {
					let timeslots = querySnapshot.documents.compactMap { document in
						try? document.data(as: FirebaseTimeSlot.self)
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
				details: firebaseTimeSlot.timeSlotDetail.toTimeSlotDetail(),
				total: firebaseTimeSlot.total)
		}
	}
}

extension FirebaseTimeSlotDetail {
	func toTimeSlotDetail() -> TimeSlotDetails {
		TimeSlotDetails(start: start, end: end, description: description)
	}
}

fileprivate struct FirebaseTimeSlot: Codable {
	var id: String
	var userId: String
	var clientId: Int
	var projectId: Int
	var date: String
	var timeSlotDetail: FirebaseTimeSlotDetail
	var total: Int
}

fileprivate struct FirebaseTimeSlotDetail: Codable {
	var start: String
	var end: String
	var description: String
}
