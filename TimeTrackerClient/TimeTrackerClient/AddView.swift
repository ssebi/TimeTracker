//
//  AddView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct AddView: View {
    //let hourPicker: String
    //let comments: String
    let clients = ["Client 1","Cient 2","Client 3","Client 4"]
    @State private var projectSelection = "Project x"
    @State private var clientSelection = "Client x"
    @State private var description: String = ""
    
    var body: some View {
        VStack{
            NavigationView{
                Form{
                    Section{
                        Picker(selection: $projectSelection, label: Text("Project")){
                            ForEach(clients, id: \.self) { client in
                                Text(client)
                            }
                        }
                        Picker(selection: $clientSelection, label: Text("Client")){
                            ForEach(clients, id: \.self) { client in
                                Text(client)
                            }
                        }
                    }
                    Section(""){
                        DatePickerView()
                    }
                    Section("Description"){
                        TextField("Coments", text: $description)
                            .multilineTextAlignment(.center)
                            .frame(height: 80, alignment: .center)
                        // sau h interval
                    }.navigationTitle("Mihai B")
                    HStack{
                        Spacer()
                        Button("submit"){}
                        .buttonStyle(AddButton())
                        Spacer()
                    }
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
