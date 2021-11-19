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
    @Published var startEndDate = StartEndDate(start: Date(), end: Date())
    @Published var timeInterval = DateComponents()
    private var path = "timeSlots"

    func addTimeSlot(for userId: String, clientId: Int, projectId: Int) {
        if userId == "" {
            return showMessage = "The user is not logged"
        }

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
            total: 0)

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
