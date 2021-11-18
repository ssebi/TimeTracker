
import Firebase
import FirebaseFirestoreSwift

class FirebaseTimeslotsLoader: TimeSlotsLoader {
    let db = Firestore.firestore()
    private var timeslots = [FirebaseTimeSlot]()

    func getTimeSlots(for user: String, with client: Int, and project: Int, completion: @escaping TimeSlotsLoader.Result) {
        db.collection(Path.timeSlot)
            .whereField("userId", isEqualTo: user)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self?.timeslots = querySnapshot.documents.compactMap { document in
                        return try? document.data(as: FirebaseTimeSlot.self)
                    }
                    completion(.success(self!.timeslots.toTimeSlot()))
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
                timeSlotDetail: firebaseTimeSlot.timeSlotDetail.toTimeSlotDetail(),
                total: firebaseTimeSlot.total)
        }
    }
}

extension FirebaseTimeSlotDetail {
    func toTimeSlotDetail() -> TimeSlotDetail {
        TimeSlotDetail(start: start, end: end, description: description)
    }
}

fileprivate struct FirebaseTimeSlot: Identifiable, Decodable, Encodable {
    @DocumentID public var id: String?
    var userId: String
    var clientId: Int
    var projectId: Int
    var date: Date
    var timeSlotDetail: FirebaseTimeSlotDetail
    var total: Int

    init(id: String, userId: String, clientId: Int, projectId: Int, date: Date, timeSlotDetail: FirebaseTimeSlotDetail, total: Int){
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
    var start: Date
    var end: Date
    var description: String

    init(start: Date, end: Date, description: String){
        self.start = start
        self.end = end
        self.description = description
    }
}
