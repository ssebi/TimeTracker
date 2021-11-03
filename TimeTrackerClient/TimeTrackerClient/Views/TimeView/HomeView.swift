//
//  HomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 18.10.2021.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
	@EnvironmentObject var dataStore: DataStore

	var body: some View {
		NavigationView {
			FilledHomeView()
		}
		.navigationTitle(
			Text("Today")
		)
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.environmentObject(DataStore())
	}
}
