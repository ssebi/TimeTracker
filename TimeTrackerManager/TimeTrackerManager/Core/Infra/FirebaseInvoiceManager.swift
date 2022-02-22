//
//  FirebaseInvoicePublisher.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 16.02.2022.
//

import Foundation
import Firebase
import TimeTrackerCore

final class FirebaseInvoiceManager {
    typealias GetTimeslotsResult = (Result<[TimeSlot], Error>) -> Void
    private var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    init() {}

    typealias InvoicePublisherCompletion = (Result<Void, Error>) -> Void
    typealias GetInvoiceResult = (Result<InvoiceNo, Error>) -> Void
    typealias GetInvoiceTotalResult = (Result<Int, Error>) -> Void
    struct UndefinedError: Error { }

    func updateInvoiceNo(newInvoiceNo: Int, docId: String, completion: @escaping InvoicePublisherCompletion) {
        Firestore.firestore().collection(Path.invoiceNo)
            .document(docId).updateData(["no": newInvoiceNo]) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }

    func getInvoiceNo(completion: @escaping GetInvoiceResult) {
        Firestore.firestore().collection(Path.invoiceNo).getDocuments { (snapshot, error) in
            guard error == nil else {
                return completion(.failure(error!))
            }
            if let snapshot = snapshot {
                let invoiceNo = snapshot.documents.compactMap { document -> InvoiceNo? in
                    let data = document.data()
                   guard let series = data["series"] as? String,
                         let no = data["no"] as? Int,
                         let documentId = document.documentID as? String else {
                             return nil
                         }
                    return InvoiceNo(id: documentId, no: no, series: series)
                }
                completion(.success(invoiceNo[invoiceNo.count - 1]))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UndefinedError()))
            }
        }
    }

    func getInvoiceTotal(clientName: String, date: Date, completion: @escaping GetInvoiceTotalResult) {
        Firestore.firestore().collection(Path.timeSlots)
            .getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let timeslots = querySnapshot.documents.compactMap { [weak self] document -> TimeSlot? in
                        if let data = try? JSONSerialization.data(withJSONObject: document.data()) {
                            return try? self?.jsonDecoder.decode(TimeSlot.self, from: data)
                        } else {
                            return nil
                        }
                    }
                    completion(.success(self.invoiceTotalForSelection(timeslots, date, clientName)))
                } else {
                    completion(.failure(error!))
                }
            }
        }

    private func invoiceTotalForSelection(_ timeslots: [TimeSlot], _ date: Date, _ client: String) -> Int {
        var arrTotalHours = [Int]()
         let clientTimeslots =  timeslots.filter { timeslot in
                timeslot.clientName == client
            }
        let timeslotsByDate = clientTimeslots.filter { timeslot in
            return  timeslot.date > date.startOfMonth() &&
                    timeslot.date <= date.endOfMonth()
        }
        timeslotsByDate.forEach { timeslot in
            arrTotalHours.append(timeslot.total)
        }
        return arrTotalHours.reduce(0, +)
    }

    func saveInvoice(title: String, data: String, completion: @escaping InvoicePublisherCompletion) {
        Firestore.firestore().collection(Path.invoice)
            .document().setData(
                [
                    "title": title,
                    "data": data,
                    "date": Date()
                ]) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
}
