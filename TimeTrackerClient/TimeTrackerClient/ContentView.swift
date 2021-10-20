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
                HomeView()
            } else {
                LoginView(session: session)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}
