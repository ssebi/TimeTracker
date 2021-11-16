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
	@EnvironmentObject var dataStore: DataStore

	var body: some View {
		NavigationView {
			ProjectView()
				.padding()
				.navigationBarItems(
					leading:
						Button(
							action: {
								session.signOut()
							},
							label: {
								Label("", systemImage: "power")
									.foregroundColor(.red)
									.font(.system(size: 20))
							}),
					trailing:
						Button(
							action: { },
							label: {
								NavigationLink(
									destination:
										AddView()
								) {
									Label("+", systemImage: "plus.rectangle.fill")
										.foregroundColor(.cGreen)
										.font(.system(size: 30))
								}
							})
				)
				.navigationTitle("Time Logged")
		}
		.onAppear(perform: getPickerData)
	}

	func getPickerData() {
		dataStore.getClients()
	}
}

// TODO: - Remove this after implementing `AddView`
struct AddView: View {
	var body: some View {
		Text("AddView")
	}
}

struct HomeView_Previews: PreviewProvider {
	class FakeAuthProvider: AuthProvider {
		func checkAuthState() -> User? { nil }
		func signIn(email: String, password: String, completion: @escaping SesionStoreResult) { }
		func signOut() throws { }
	}
	
	static var previews: some View {
		HomeView()
			.environmentObject(DataStore())
			.environmentObject(SessionStore(authProvider: FakeAuthProvider()))
	}
}
