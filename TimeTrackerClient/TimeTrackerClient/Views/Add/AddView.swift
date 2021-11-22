//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var timeSlotVM = TimeSlotViewModel(clientsLoader: FirebaseClientsLoader())

    var body: some View {
        VStack {
            Text(Date(), style: .date)
                .padding()
                .font(.subheadline)

			if !timeSlotVM.isLoading {
				Picker(selection: $timeSlotVM.selectedClient, label: Text("")) {
					ForEach(0 ..< timeSlotVM.clientsNames.count){ index in
						Text(timeSlotVM.clientsNames[index])
					}
				}
				.labelsHidden()
				.frame(width: UIScreen.main.bounds.width - 50 , height: 60, alignment: .center)
				.background(Color.cGray)
				.foregroundColor(.white)

				Picker(selection: $timeSlotVM.selectedProject, label: Text("")){
					ForEach(0 ..< timeSlotVM.projectNames.count) { index in
						Text(timeSlotVM.projectNames[index])
					}
				}
				.id(timeSlotVM.id)
				.labelsHidden()
				.frame(width: UIScreen.main.bounds.width - 50 , height: 60, alignment: .center)
				.background(Color.cGray)
				.foregroundColor(.white)
			}

            Spacer()
            
            DatePickerView(
                startEndDate: $timeSlotVM.startEndDate,
                timeInterval: $timeSlotVM.timeInterval,
                timeSlotVM: timeSlotVM
            )
                .padding()

            HStack {
                Text("Task description")
                    .padding()
                Spacer()
            }
            TextEditor(text: $timeSlotVM.description)
                .border(.gray)
                .frame(width: UIScreen.width - 55, height: 130, alignment: .center)

            Spacer()
            HStack {
                Text("\(timeSlotVM.showMessage)")
                Spacer()
            }

            Button("SUBMIT") {
                addTimeSlot()
            }
            .buttonStyle(AddButton())
            .frame(width: UIScreen.main.bounds.width - 50, height: 100, alignment: .center)
        }
    }

    func addTimeSlot() {
        let userId = session.user?.uid ?? ""
        let clientId = timeSlotVM.selectedClient
        let projectId = timeSlotVM.selectedProject
        timeSlotVM.addTimeSlot(for: userId, clientId: clientId, projectId: projectId )
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
