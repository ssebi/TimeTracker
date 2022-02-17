//
//  FirebaseInvoicePublisher.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 16.02.2022.
//

import Foundation
import Firebase

final class FirebaseInvoiceManager {
    typealias InvoicePublisherCompletion = (Result<Void, Error>) -> Void
    typealias GetInvoiceResult = (Result<InvoiceNo, Error>) -> Void
    typealias GetInvoiceTotalResult = (Result<InvoiceTotal, Error>) -> Void
    public struct UndefinedError: Error { }

    public func updateInvoiceNo(newInvoiceNo: Int, docId: String, completion: @escaping InvoicePublisherCompletion) {
        Firestore.firestore().collection(Path.invoieNo)
            .document(docId).updateData(["no": newInvoiceNo]) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }

    public func getInvoiceNo(completion: @escaping GetInvoiceResult) {
        Firestore.firestore().collection(Path.invoieNo).getDocuments { (snapshot, error) in
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

    public func getInvoiceTotal(clientId: String, date: Date, completion: @escaping GetInvoiceTotalResult) {
        Firestore.firestore().collection(Path.timeSlots)
            .whereField("clientId", isEqualTo: clientId).whereField("date", isGreaterThan: date)
            .getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let invoiceTotal = querySnapshot.documents.compactMap { document -> InvoiceTotal? in
                        let data = document.data()
                            print("===>>>>DATA", data)
                        return InvoiceTotal(total: "", date: Date())
                    }
                    completion(.success(invoiceTotal[0]))
                } else {
                    completion(.failure(error!))
                }
            }
    }
}
