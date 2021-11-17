
import Firebase

class FirebaseTimeslotsLoader: TimeSlotsLoader {
    let db = Firestore.firestore()
    var timeslots = [TimeSlot]()
    
    func getTimeSlots(for user: String, with client: Int, and project: Int, completion: @escaping TimeSlotsLoader.Result) {
        db.collection(Path.timeSlot)
            .whereField("userId", isEqualTo: user)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self?.timeslots = querySnapshot.documents.compactMap{ document in
                        let data = document.data()
                        let clientId = data["clientId"] as! Int
                        let date = (data["date"] as! Timestamp).dateValue()
                        let projectId = data["projectId"] as! Int
                        let tsMap = data["timeSlotDetail"] as! [String: Any]
                        var tsDetail = [String: Any]()
                        for (key, value) in tsMap {
                            tsDetail[key] = value
                        }
                        let start = (tsDetail["start"] as! Timestamp).dateValue()
                        let end = (tsDetail["end"] as! Timestamp).dateValue()
                        let description = tsDetail["description"] as! String
                        
                        let timeSlotDetail = TimeSlotDetail(start: start, end: end, description: description)
                        let total = data["total"] as! Int
                        let userId = data["userId"] as! String
                        return TimeSlot(
                            id: document.documentID,
                            userId: userId,
                            clientId: clientId,
                            projectId: projectId,
                            date: date,
                            timeSlotDetail: timeSlotDetail,
                            total: total
                        )
                    }
                    completion(.success(self!.timeslots))
                } else {
                    completion(.failure(error!))
                }
            }
    }
}
