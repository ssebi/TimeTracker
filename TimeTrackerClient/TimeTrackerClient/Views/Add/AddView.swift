//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var keyboardResponder = KeyboardResponder()
	@ObservedObject var timeSlotVM: TimeSlotViewModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack{
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
                        Text("Task description")
                            .font(Font.custom("Avenir-Next", size: 20))
                            .padding()
                        Spacer()
                    }

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
                .blur(radius: timeSlotVM.showValidationAlert ? 30 : 0)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .offset(y: -keyboardResponder.currentHeight*0.9)

            }
            .padding()

            if timeSlotVM.showValidationAlert {
                CustomAlertView(isValid: timeSlotVM.isValid, message: $timeSlotVM.showMessage)
            }

        }

    }

    func addTimeSlot() {
        timeSlotVM.showValidationAlert = true
        let clientName = timeSlotVM.clientsNames[timeSlotVM.selectedClient]
        let projectName = timeSlotVM.projectNames[timeSlotVM.selectedProject]
        timeSlotVM.addTimeSlot(clientName: clientName, projectName: projectName )
        if (timeSlotVM.isValid) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(timeSlotVM: TimeSlotViewModel(
			clientsLoader: ClientLoaderMock(store: MockClientsStore()),
			timeslotPublisher: TimeSlotsPublisherMock(store: MockTimeslotStore()),
			userLoader: UserLoaderMock()))
    }

	private class MockClientsStore: ClientsStore {
		func getClients(completion: @escaping GetClientsResult) { }
	}
	private class ClientLoaderMock: ClientsLoader {
		var store: ClientsStore
		init(store: ClientsStore) {
			self.store = store
		}
		func getClients(completion: @escaping (Result<[Client], Error>) -> Void) {
			completion(.success([]))
		}
	}

	private class MockTimeslotStore: TimeslotsStore {
		func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) { }
		func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) { }
	}
	private class TimeSlotsPublisherMock: TimeSlotsPublisher {
		var store: TimeslotsStore
		init(store: TimeslotsStore) {
			self.store = store
		}
		func addTimeSlot(_ timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
			completion(nil)
		}
	}

	private class UserLoaderMock: UserLoader {
		func getUser() -> User {
			User(uid: UUID().uuidString, email: "somteEmail@test.com", username: "Test", client: "Client")
		}
	}
}
