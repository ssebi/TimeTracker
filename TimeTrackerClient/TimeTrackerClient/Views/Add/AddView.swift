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
    @State private var description = ""
    @State private var showMessage = ""
    @State private var startEndDate = StartEndDate(start: Date.now, end: Date.now)

    var body: some View {
        VStack {
            Text(Date(), style: .date)
                .padding()
                .font(.subheadline)

            Picker(selection: $dataStore.selectedClient, label: Text("")){
                ForEach(0 ..< dataStore.clientsNames.count){ index in
                    Text(self.dataStore.clientsNames[index])
                }
            }
            .labelsHidden()
            .frame(width: UIScreen.main.bounds.width - 50 , height: 60, alignment: .center)
            .background(Color.cGray)
            .foregroundColor(.white)

            Picker(selection: $dataStore.selectedProject, label: Text("")){
                ForEach(0 ..< dataStore.projectNames.count){ index in
                    Text(self.dataStore.projectNames[index])
                }
            }
            .id(dataStore.id)
            .labelsHidden()
            .frame(width: UIScreen.main.bounds.width - 50 , height: 60, alignment: .center)
            .background(Color.cGray)
            .foregroundColor(.white)

            Spacer()

            DatePickerView(startEndDate: $startEndDate)
                .padding()

            HStack {
                Text("Task description")
                    .padding()
                Spacer()
            }
            TextEditor(text: $description)
                .border(.gray)
                .frame(width: UIScreen.width - 55, height: 130, alignment: .center)

            Spacer()
            HStack {
                Text("\(showMessage)")
                Spacer()
            }

            Button("SUBMIT") {
                addTime()
            }
            .buttonStyle(AddButton())
            .frame(width: UIScreen.main.bounds.width - 50, height: 100, alignment: .center)
        }.onAppear(perform: getPickerData)
    }

    func getPickerData() {
        dataStore.fetchUsersClients()
    }

    func addTime() {
        let user = session.session
        let userId = user?.uid ?? ""
        var path = ""
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        let date = dateFormater.string(from: startEndDate.start)

        if user != nil {
            path = "userId/\(userId)/clients/\(dataStore.clientsNames[dataStore.selectedClient])/projects/\(dataStore.projectNames[dataStore.selectedProject])/timeLogged/\(date)/timeslots"

        }

        let timeslot: [String: Any] = [
            "timeSlots": [
                "start": startEndDate.start,
                "end": startEndDate.end,
                "description": description ],
            "total": 5
        ]

        dataStore.addTimeSlot(with: timeslot, to: path) { error in
            if error != nil {
                showMessage = "Failed to save"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showMessage = ""
                }
            } else {
                showMessage = "Time logged saved"
                description = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showMessage = ""
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
