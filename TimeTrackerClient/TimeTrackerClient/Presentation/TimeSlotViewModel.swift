//
//  TimeSlotViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 18.11.2021.
//

import Foundation
import SwiftUI

class TimeSlotViewModel: ObservableObject {
	@Published var isLoading = false
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

	let clientsLoader: ClientsLoader
	@Published var clients = [Client]()
	@Published var id: UUID = UUID()
	@Published var selectedClient: Int = 0 {
		didSet {
			selectedProject = projectSelections[selectedClient] ?? 0
			id = UUID()
		}
	}
	@Published var selectedProject: Int = 0 {
		didSet {
			DispatchQueue.main.async { [selectedProject] in
				self.projectSelections[self.selectedClient] = selectedProject
			}
		}
	}

	private var projectSelections: [Int: Int] = [:]
	var clientsNames: [String] {
		clients.map { (project) in
			project.name
		}
	}
	var projectNamesCount: Int {
		projectNames.count
	}
	var projectNames: [String] {
		guard !clients.isEmpty else {
			return [String]()
		}
		return clients[selectedClient].projects.map { (project) in
			return project.name
		}
	}
	
	init(clientsLoader: ClientsLoader) {
		self.clientsLoader = clientsLoader

		isLoading = true
		clientsLoader.getClients { [weak self] result in
			guard let self = self else {
				return
			}
			if let clients = try? result.get() {
				self.clients = clients
			}
			self.isLoading = false
		}
	}

    func addTimeSlot(for userId: String, clientId: Int, projectId: Int) {
        if userId == "" {
            return showMessage = "The user is not logged"
        }

        timeInterval = Calendar.current.dateComponents([.hour, .minute], from: startEndDate.start, to: startEndDate.end)

        let total = ((timeInterval.hour ?? 0)*60) + (timeInterval.minute ?? 0)

        let timeSlotDetail = TimeSlotDetails(
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
            details: timeSlotDetail,
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
}