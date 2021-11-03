//
//  ContentView.swift
//  TimeTrackerClient
//
//  Created by Sebastian Vidrea on 11.10.2021.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var dataStore: DataStore
	@EnvironmentObject var sessionStore: SessionStore

	var body: some View {
		Group {
			if(sessionStore.session != nil ) {
				HomeView()
			} else {
				LoginView(session: sessionStore)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(SessionStore())
			.environmentObject(DataStore())
	}
}
