//
//  TimeSlotViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 18.11.2021.
//

import Foundation
import SwiftUI

class TimeSlotViewModel: ObservableObject {
    var dataStore = DataStore()
    @Published var description = ""
    @Published var showMessage = ""
    @Published var timeInterval = DateComponents()
    @Published var startEndDate = StartEndDate(start: Date(), end: Date())

    private var path = "timeSlots"

    let dateFormatter = DateFormatter()

    func addTimeSlot(for userId: String, clientId: Int, projectId: Int) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var date = dateFormatter.date(from: "\(startEndDate.start)")

        if userId == "" {
            return showMessage = "The user is not logged"
        }

        timeInterval = Calendar.current.dateComponents([.hour, .minute], from: startEndDate.start, to: startEndDate.end)
        let total = ((timeInterval.hour ?? 0)*60) + (timeInterval.minute ?? 0)

        let timeSlotDetail = TimeSlotDetail(
            start: startEndDate.start,
            end: startEndDate.end,
            description: description
        )

        let timeSlot = TimeSlot(
            id: UUID().uuidString,
            userId: userId,
            clientId: clientId,
            projectId: projectId,
            date: startEndDate.start,
            timeSlotDetail: timeSlotDetail,
            total: total)

        dataStore.addTimeSlot(timeSlot: timeSlot, to: path) { result in
            if case .success(_) = result {
                self.showMessage = "Time logged saved"
                self.description = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.showMessage = ""
                }
            } else {
                self.showMessage = "Failed to save"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.showMessage = ""
                }
            }
        }
    }

    init() {}
}
