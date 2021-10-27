//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    let clients = ["Client 1","Cient 2","Client 3","Client 4"]
    let projects = ["Project 1","Project 2","Project 3","Project 4"]
    @State private var projectSelection = "Project x"
    @State private var clientSelection = "Client x"
    @State private var description: String = ""
    var dataStore = DataStore()
    
    var body: some View {
        VStack {
            NavigationView {
                VStack{
                    Section {
                        Picker(selection: $projectSelection, label: Text("Project")) {
                            ForEach(clients, id: \.self) { client in
                                Text(client)
                            }
                        }
                        Picker(selection: $clientSelection, label: Text("Client")) {
                            ForEach(projects, id: \.self) { client in
                                Text(client)
                            }
                        }
                    }
                    Section {
                        DatePickerView()
                    }
                    .padding()
                    Section("Description") {
                        TextField("Coments", text: $description)
                            .multilineTextAlignment(.center)
                            .frame(height: 80, alignment: .center)
                            .border(Color.cBlack)
                    }.navigationTitle("Mihai B")
                        .padding()
                    HStack{
                        Spacer()
                        Button("submit") {
                            addTime()
                        }
                        .buttonStyle(AddButton())
                        Spacer()
                    }
                    .background(Color.cGreen)
                    .padding()
                }
                .padding()
            }
        }
    }
    
    func addTime(){
        print("444444444")
        let data: [String: Any] = [
            "date": "20-10-2021",
            "timeSlots": [
                [
                    "start": "20-10-2021T12:00:00Z",
                    "end": "20-10-2021T15:00:00Z",
                    "description": $description
                ],
            ],
        ]
        
        dataStore.addTimeSlot(with: data, to: projectSelection){ error in }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
