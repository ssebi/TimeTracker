//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var keyboardResponder = KeyboardResponder()
    // TODO: - Move ViewModel initialization in a factory method
    @ObservedObject var timeSlotVM = TimeSlotViewModel(clientsLoader: RemoteClientsLoader(store: FirebaseClientsStore()),
                                                       timeslotPublisher: RemoteTimeSlotsPublisher(store: FirebaseTimeslotsStore()),
                                                       userLoader: FirebaseUserLoader())

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if !timeSlotVM.isLoading {
                    HStack {
                        Picker(selection: $timeSlotVM.selectedClient,
                               label: Text("\(timeSlotVM.clientsNames[timeSlotVM.selectedClient])")
                        ){
                            ForEach(0 ..< timeSlotVM.clientsNames.count) { index in
                                Text(timeSlotVM.clientsNames[index])
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: (UIScreen.width - 55) / 2, height: 40)
                        .background(Color.cGray)
                        .foregroundColor(.cBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))

                        Spacer()

                        Picker(selection: $timeSlotVM.selectedProject,
                               label: Text("\(timeSlotVM.projectNames[timeSlotVM.selectedProject])")
                        ){
                            ForEach(0 ..< timeSlotVM.projectNames.count) { index in
                                Text(timeSlotVM.projectNames[index])
                            }
                        }
                        .id(timeSlotVM.id)
                        .pickerStyle(.menu)
                        .frame(width: (UIScreen.width - 55) / 2, height: 40)
                        .background(Color.cGray)
                        .foregroundColor(.cBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                    .padding()
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
                }.font(Font.custom("Avenir-Next", size: 20))

                TextEditor(text: $timeSlotVM.description)
                    .border(LinearGradient.gradientButton)
                    .frame(width: UIScreen.width - 55, height: 80, alignment: .center)

                Spacer()

                HStack {
                    Text("\(timeSlotVM.showMessage)")
                        .font(Font.custom("Avenir-Next", size: 20))
                    Spacer()
                }

                Button("SUBMIT") {
                    addTimeSlot()
                }
                .buttonStyle(AddButton())
                .navigationBarItems(trailing: Text(Date(), style: .date)
                                        .padding()
                                        .font(.subheadline))
                .navigationTitle("Add work log")
            }
        }
        .padding()
    }

    func addTimeSlot() {
        let clientName = timeSlotVM.clientsNames[timeSlotVM.selectedClient]
        let projectName = timeSlotVM.projectNames[timeSlotVM.selectedProject]

        timeSlotVM.addTimeSlot(clientName: clientName, projectName: projectName )
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
