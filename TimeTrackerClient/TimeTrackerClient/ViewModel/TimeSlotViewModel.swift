//
//  TimeSlotViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 18.11.2021.
//

import Foundation
import SwiftUI

class TimeSlotViewModel: ObservableObject {
    @EnvironmentObject var session: SessionStore
    @Published var description = ""
    @Published var showMessage = ""
    @Published var timeInterval = DateComponents()
    @Published var startEndDate = StartEndDate(start: Date(), end: Date())
    @State var dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2121, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from: startComponents)!
        ...
        calendar.date(from: endComponents)!
    }()

    private var path = "timeSlots"
    var dataStore = DataStore()

    func formatDate(date: Date) -> String {
		if #available(iOS 15.0, *) {
			return date.formatted(.iso8601)
		} else {
			return ISO8601DateFormatter().string(from: date)
		}
    }

    func addTimeSlot(for userId: String, clientId: Int, projectId: Int) {

        if userId == "" {
            return showMessage = "The user is not logged"
        }

        timeInterval = Calendar.current.dateComponents([.hour, .minute], from: startEndDate.start, to: startEndDate.end)

        let total = ((timeInterval.hour ?? 0)*60) + (timeInterval.minute ?? 0)

        let date = formatDate(date: startEndDate.start)
        let startDate = formatDate(date: startEndDate.start)
        let endDate = formatDate(date: startEndDate.start)

        let timeSlotDetail = TimeSlotDetail(
            start: startDate,
            end: endDate,
            description: description
        )



        let timeSlot = TimeSlot(
            id: UUID().uuidString,
            userId: userId,
            clientId: clientId,
            projectId: projectId,
            date: date,
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
