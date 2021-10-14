//
//  ContentView.swift
//  TimeTrackerClient
//
//  Created by Sebastian Vidrea on 11.10.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        Group{
            if(session.session != nil ) {
                Text("Hello!")
            } else {
                LoginView()
            }
        }.onAppear(perform: getUser)
    }
    
    func getUser(){
        self.session.listen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}


