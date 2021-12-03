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
    @ObservedObject var timeSlotVM = TimeSlotViewModel(clientsLoader: RemoteClientsLoader(store: FirebaseClientsStore()), timeslotPublisher: RemoteTimeSlotsPublisher(store: FirebaseTimeslotsStore()), userLoader: FirebaseUserLoader())
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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
                                    .foregroundColor(.cBlack)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: (UIScreen.width - 55) / 2, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.cBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))

                        Spacer()

                        Picker(selection: $timeSlotVM.selectedProject,
                               label: Text("\(timeSlotVM.projectNames[timeSlotVM.selectedProject])")
                        ){
                            ForEach(0 ..< timeSlotVM.projectNames.count) { index in
                                Text(timeSlotVM.projectNames[index])
                                    .foregroundColor(.cBlack)
                            }
                        }
                        .id(timeSlotVM.id)
                        .pickerStyle(.menu)
                        .frame(width: (UIScreen.width - 55) / 2, height: 40)
                        .background(Color.gray.opacity(0.2))
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
                    Text(timeSlotVM.showMessage)
                        .padding()
                        .foregroundColor(.red)
                    Spacer()
                }

                HStack {
                    Text("Task description")
                        .padding()
                    Spacer()
                }.font(Font.custom("Avenir-Next", size: 20))

                TextEditor(text: $timeSlotVM.description)
                    .border(LinearGradient.gradientBackground)
                    .frame(width: UIScreen.width - 55, height: 80, alignment: .center)

                Spacer()

                Button("SUBMIT") {
                    addTimeSlot()
                }
                .buttonStyle(AddButton())
                .navigationBarItems(trailing: Text(Date(), style: .date)
                                        .padding()
                                        .font(.subheadline))
                .navigationTitle("Add work log")
            }
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            .offset(y: -keyboardResponder.currentHeight*0.5)

        }
        .padding()
    }

    func addTimeSlot() {
        let clientName = timeSlotVM.clientsNames[timeSlotVM.selectedClient]
        let projectName = timeSlotVM.projectNames[timeSlotVM.selectedProject]
        timeSlotVM.addTimeSlot(clientName: clientName, projectName: projectName )
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
