//
//  HomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 18.10.2021.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var userData: DataStore
    
    @State var hasData: Bool = false
    
    //loading
    typealias document = (Result<QuerySnapshot, Error>) -> Void
    var body: some View {
        VStack {
            NavigationView{
                if userData.timeslot != "" {
                    FilledHomeView()
                } else {
                    Text("There is no time logged for this user")
                }
                Spacer()
            }
            .navigationBarItems(trailing: HStack{
                Button("+"){}
                .buttonStyle(AddBarButton())
            })
            .navigationTitle(
                Text("Today")
            )
        }.onAppear(perform: getUserTimeLogs)
    }
    
    func getUserTimeLogs() {
        //
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
