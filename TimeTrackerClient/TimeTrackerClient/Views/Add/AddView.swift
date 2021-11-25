//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    // TODO: - Move ViewModel initialization in a factory method
    @ObservedObject var timeSlotVM = TimeSlotViewModel(clientsLoader: RemoteClientsLoader(store: FirebaseClientsStore()),
                                                       timeslotPublisher: RemoteTimeSlotsPublisher(store: FirebaseTimeslotsStore()),
                                                       userLoader: FirebaseUserLoader())

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text(Date(), style: .date)
                    .padding()
                    .font(.subheadline)

                if !timeSlotVM.isLoading {
                    HStack {
                        Picker(selection: $timeSlotVM.selectedClient, label: Text("\(timeSlotVM.selectedClient)").frame(width: 100, height: 100, alignment: .center)
                                .foregroundColor(.red)) {
                            ForEach(0 ..< timeSlotVM.clientsNames.count) { index in
                                Text(timeSlotVM.clientsNames[index])
                            }
                        }.pickerStyle(.menu)

                        Picker(selection: $timeSlotVM.selectedProject, label: Text("")){
                            ForEach(0 ..< timeSlotVM.projectNames.count) { index in
                                Text(timeSlotVM.projectNames[index])
                            }
                        }
                        .id(timeSlotVM.id)
                        .pickerStyle(MenuPickerStyle())
                    }
                }

                Spacer()

                DatePickerView(
                    startEndDate: $timeSlotVM.startEndDate,
                    timeInterval: $timeSlotVM.timeInterval,
                    dateRange: timeSlotVM.dateRange
                )
                    .padding()

                HStack {
                    Text("Task description")
                        .padding()
                    Spacer()
                }
                TextEditor(text: $timeSlotVM.description)
                    .border(.gray)
                    .frame(width: UIScreen.width - 55, height: 80, alignment: .center)

                Spacer()
                HStack {
                    Text("\(timeSlotVM.showMessage)")
                    Spacer()
                }

                Button("SUBMIT") {
                    addTimeSlot()
                }
                .buttonStyle(AddButton())
            }
        }
        .padding()
    }

    func addTimeSlot() {
        let clientId = timeSlotVM.selectedClient
        let projectId = timeSlotVM.selectedProject
        timeSlotVM.addTimeSlot(clientId: clientId, projectId: projectId )
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
