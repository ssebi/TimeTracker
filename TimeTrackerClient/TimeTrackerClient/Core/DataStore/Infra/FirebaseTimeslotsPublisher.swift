
import Firebase

class FirebaseTimeslotsPublisher: TimeSlotsPublisher {
    let db = Firestore.firestore()

    func addTimeSlots(timeSlot: TimeSlot, to path: String, completion: @escaping TimeSlotsPublisher.Result) {
        var data: [String: Any] = [:]
        do{
            let jsonEncoder = JSONEncoder()
			jsonEncoder.dateEncodingStrategy = .iso8601
            let encodedJson = try jsonEncoder.encode(timeSlot)
            data = try JSONSerialization.jsonObject(with: encodedJson) as! [String : Any]
        } catch {
            completion(.failure(error))
        }

        db.collection(path).document().setData(data) { error in
            if error != nil {
                completion(.failure(error!))
                return
            }
            completion(.success(timeSlot))
        }
    }
}
