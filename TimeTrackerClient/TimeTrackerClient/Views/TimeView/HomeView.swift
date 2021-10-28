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
    var dataStore = DataStore()
    @State var hasData: Bool = false
    
    var body: some View {
        VStack{
            HStack(){
                Text("Today")
                    .padding()
                    .frame(alignment: .leading)
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(Date(), style:  .date)
                    .padding()
                    .font(.subheadline)
            }
            Spacer()
            if hasData {
                FilledHomeView()
            } else {
                EmptyHomeView()
            }
            //AddView()
            Spacer()
        }.onAppear(perform: getUserTimeLogs)
    }
    
    func getUserTimeLogs() {
        let userId = session.session?.uid
        let path = "userId"
        if session.session != nil {
            dataStore.getTimeSlot(from: path) { result in
                hasData = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
