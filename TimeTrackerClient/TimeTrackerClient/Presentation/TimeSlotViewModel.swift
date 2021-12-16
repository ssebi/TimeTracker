//
//  TimeSlotViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 18.11.2021.
//

import SwiftUI

class TimeSlotViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var description = ""
    @Published var showMessage = ""
    @Published var timeInterval = DateComponents()
    @Published var isValid = false
    @Published var showValidationAlert = false
    @Published var startEndDate = StartEndDate(
        start: Date(),
        end: Calendar.current.date(byAdding: .hour, value: 1, to: Date())?.addingTimeInterval(1) ?? Date()) {
        didSet {
            timeInterval = Calendar.current.dateComponents([.hour, .minute], from: startEndDate.start, to: startEndDate.end)
        }
    }
    @State var dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2121, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from: startComponents)!
        ...
        calendar.date(from: endComponents)!
    }()

    private let clientsLoader: ClientsLoader
    private let timeslotPublisher: TimeSlotsPublisher
    private let userLoader: UserLoader
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

    init(clientsLoader: ClientsLoader, timeslotPublisher: TimeSlotsPublisher, userLoader: UserLoader) {
        self.clientsLoader = clientsLoader
        self.timeslotPublisher = timeslotPublisher
        self.userLoader = userLoader

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
        timeInterval = Calendar.current.dateComponents([.hour, .minute], from: startEndDate.start, to: startEndDate.end)
    }


    func addTimeSlot(clientName: String, projectName: String) {
        isValid = false
        guard let userID = userLoader.getUser().uid else {
            return showMessage = "The user is not logged!"
        }



        let total = ((timeInterval.hour ?? 0)*60) + (timeInterval.minute ?? 0)

        let timeSlotDetail = TimeSlotDetails(
            start: startEndDate.start,
            end: startEndDate.end,
            description: description
        )

        let dateComponent = Calendar.current.dateComponents([.day, .year, .month], from: startEndDate.start)
        let date = Calendar.current.date(from:dateComponent) ?? startEndDate.start

        let timeSlot = TimeSlot(
            id: UUID().uuidString,
            userId: userID,
            clientName: clientName,
            projectName: projectName,
            date: date,
            details: timeSlotDetail,
            total: total)

        if (total == 0) {
            self.showMessage = "You must select a time interval!"
            isValid = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showValidationAlert = false
                self.showMessage = ""
            }
        }

        if (timeSlotDetail.description == "") {
            self.showMessage = "Provide a task description!"
            isValid = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showValidationAlert = false
                self.showMessage = ""
            }
        }

		if !timeSlotDetail.description.isEmpty && total != 0 {
			isValid = true
		}

        if isValid {
            timeslotPublisher.addTimeSlot(timeSlot) { error in
                if error == nil {
                    self.showMessage = "Time logged saved"
                    self.description = ""
                    self.showValidationAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.showMessage = ""
                        self.showValidationAlert = false
                    }
                } else {
                    self.showMessage = "Something went wrong"
                    self.showValidationAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.showMessage = ""
                        self.showValidationAlert = false
                    }
                }
            }
        }
    }
}
