//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    
    @EnvironmentObject var session: SessionStore
    
    let clients = ["Client 1","Cient 2","Client 3","Client 4"]
    let projects = ["Project 1","Project 2","Project 3","Project 4"]
    @State private var projectSelection = "Project x"
    @State private var clientSelection = "Client x"
    @State private var description = ""
    @State private var showMessage = ""
    var dataStore = DataStore()
    
    var body: some View {
        VStack {
            NavigationView {
                VStack{
                    Picker(selection: $projectSelection, label: Text("Project")) {
                        ForEach(clients, id: \.self) { client in
                            Text(client)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width-50 , height: 60, alignment: .center)
                    .background(Color.cGray)
                    .foregroundColor(.white)
                    
                    Picker(selection: $clientSelection, label: Text("Client")) {
                        ForEach(projects, id: \.self) { client in
                            Text(client)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width-50 , height: 60, alignment: .center)
                    .background(Color.cGray)
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    DatePickerView()
                        .padding()
                    
                    HStack{
                        Text("Task description")
                        Spacer()
                    }
                    TextEditor(text: $description)
                        .border(.gray)
                        .frame(width: UIScreen.width-50, height: 130, alignment: .center)
                    
                    Spacer()
                    HStack{
                        Text("\(showMessage)")
                        Spacer()
                    }
                    
                    Button("submit") {
                        addTime()
                    }
                    .buttonStyle(AddButton())
                    .frame(width: UIScreen.main.bounds.width-50, height: 100, alignment: .center)
                    
                }
                .navigationTitle("Mihai B")
                .padding()
            }
            
        }
    }
    
    func addTime() {
        let user = session.session
        let userId = user?.uid ?? ""
        var path = ""
        if user != nil {
            path = "userId/\(userId)/\(clientSelection)/\(projectSelection)/timelLoged/19-01-2021/timeslots"
        }
        
        print("time log saved")
        
        let timeslot: [String: Any] = [
            "timeSlots": [
                "start": "21-10-2022T12:11:00Z",
                "end": "21-10-2021T15:10:00Z",
                "description": description ],
            "total": 5
        ]
        
        dataStore.addTimeSlot(with: timeslot, to: path){ error in
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
