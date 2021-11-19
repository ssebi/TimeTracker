
import Firebase
import FirebaseFirestoreSwift

class FirebaseTimeslotsStore: TimeslotsStore {

	func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
		Firestore.firestore().collection(Path.timeSlot)
			.whereField("userId", isEqualTo: userID)
			.addSnapshotListener { (querySnapshot, error) in
				if let querySnapshot = querySnapshot {
					let timeslots = querySnapshot.documents.compactMap { document in
						return try? document.data(as: FirebaseTimeSlot.self)
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
            guard let id = firebaseTimeSlot.id else { return nil }
            return TimeSlot(
                id: id,
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

fileprivate struct FirebaseTimeSlot: Identifiable, Decodable, Encodable {
    @DocumentID public var id: String?
    var userId: String
    var clientId: Int
    var projectId: Int
    var date: String
    var timeSlotDetail: FirebaseTimeSlotDetail
    var total: Int

    init(id: String, userId: String, clientId: Int, projectId: Int, date: String, timeSlotDetail: FirebaseTimeSlotDetail, total: Int){
        self.id = id
        self.userId = userId
        self.clientId = clientId
        self.projectId = projectId
        self.date = date
        self.timeSlotDetail = timeSlotDetail
        self.total = total
    }
}

fileprivate struct FirebaseTimeSlotDetail: Codable {
    var start: String
    var end: String
    var description: String

    init(start: String, end: String, description: String){
        self.start = start
        self.end = end
        self.description = description
    }
}
