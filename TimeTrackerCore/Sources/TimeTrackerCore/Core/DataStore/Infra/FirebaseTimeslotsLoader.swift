
import FirebaseFirestore

public class FirebaseTimeslotsStore: TimeslotsStore {
	private var jsonDecoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()

	private var jsonEncoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		return encoder
	}()

    public init(){}

    public func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
        Firestore.firestore().collection(Path.timeSlot)
            .whereField("userId", isEqualTo: userID)
            .getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let timeslots = querySnapshot.documents.compactMap { [weak self] document -> FirebaseTimeSlot? in
                        if let data = try? JSONSerialization.data(withJSONObject: document.data()) {
							return try? self?.jsonDecoder.decode(FirebaseTimeSlot.self, from: data)
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

    public func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
        var data: [String: Any] = [:]
        do {
            let encodedJson = try jsonEncoder.encode(timeSlot)
            data = try JSONSerialization.jsonObject(with: encodedJson) as! [String : Any]

            Firestore.firestore().collection("timeSlots").document().setData(data) { error in
                if error != nil {
                    completion(error!)
                    return
                }
                completion(nil)
            }
            
        } catch {
            completion(error)
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
