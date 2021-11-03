//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var userData: DataStore

    @State private var clientSelection = "Client x"
    @State private var projectSelection = "Project x"
    @State private var description = ""
    @State private var showMessage = ""
	@State private var startEndDate = StartEndDate(start: Date.now, end: Date.now)

	private let clients = ["Client x", "Client 1", "Cient 2", "Client 3", "Client 4"]
	private let projects = ["Project x", "Project 1", "Project 2", "Project 3", "Project 4"]
    private var dataStore = DataStore()
    
    var body: some View {
        VStack {
            Text(Date(), style:  .date)
                .padding()
                .font(.subheadline)
            Picker(selection: $projectSelection, label: Text("Project")) {
                ForEach(clients, id: \.self) { client in
                    Text(client)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 50 , height: 60, alignment: .center)
            .background(Color.cGray)
            .foregroundColor(.white)
            
            Picker(selection: $clientSelection, label: Text("Client")) {
                ForEach(projects, id: \.self) { client in
                    Text(client)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 50 , height: 60, alignment: .center)
            .background(Color.cGray)
            .foregroundColor(.white)
            
            Spacer()
            
            DatePickerView()
                .environmentObject(startEndDate)
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
            
            
        }
    }
    
    func addTime() {
        let user = session.session
        let userId = user?.uid ?? ""
        var path = ""
        let today = Date.now
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        let date = dateFormater.string(from: today)
        
        if user != nil {
            path = "userId/\(userId)/\(clientSelection)/\(projectSelection)/timelLoged/\(date)/timeslots"
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
