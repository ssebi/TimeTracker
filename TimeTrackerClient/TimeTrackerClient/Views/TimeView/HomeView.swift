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
            if userData.timeslot != "" {
                FilledHomeView()
            } else {
                EmptyHomeView()
            }
            Spacer()
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
