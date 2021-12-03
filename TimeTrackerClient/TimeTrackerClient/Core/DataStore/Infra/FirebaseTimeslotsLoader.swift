
import Firebase
import FirebaseFirestoreSwift

class FirebaseTimeslotsStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		Firestore.firestore().collection(Path.timeSlot)
			.whereField("userId", isEqualTo: userID)
            //.order(by: "date")
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

	func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
		var data: [String: Any] = [:]
		do{
			let jsonEncoder = JSONEncoder()
			jsonEncoder.dateEncodingStrategy = .iso8601
			let encodedJson = try jsonEncoder.encode(timeSlot)
			data = try JSONSerialization.jsonObject(with: encodedJson) as! [String : Any]
		} catch {
			completion(error)
		}

		Firestore.firestore().collection("timeSlots").document().setData(data) { error in
			if error != nil {
				completion(error!)
				return
			}
			completion(nil)
		}
	}

}

private extension Sequence where Element == FirebaseTimeSlot {
	func toTimeSlot() -> [TimeSlot] {
		compactMap { firebaseTimeSlot -> TimeSlot? in
			TimeSlot(
				id: firebaseTimeSlot.id,
				userId: firebaseTimeSlot.userId,
				clientName: firebaseTimeSlot.clientName,
                projectName: firebaseTimeSlot.projectName,
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
	var clientName: String
	var projectName: String
	var date: Date
	var details: FirebaseTimeSlotDetails
	var total: Int
}

private struct FirebaseTimeSlotDetails: Codable {
	var start: Date
	var end: Date
	var description: String
}
