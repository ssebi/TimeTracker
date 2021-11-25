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

	@ObservedObject private(set) var viewModel: HomeScreenViewModel

	var body: some View {
		NavigationView {
            ScrollView{
                ForEach(viewModel.timeslots) { timeslot in
                    ProjectView(timeslot: timeslot)
                        .padding([.trailing, .leading, .top])
                }
            }
			.navigationBarItems(
				leading:
					Button(
						action: {
							session.signOut()
						},
						label: {
							Image(systemName: "power")
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
								Image(systemName: "plus.rectangle.fill")
                                    .gradientForeground(colors: [.caribeanGreen, .cBlue])
									.font(.system(size: 30))
							}
						})
			)
			.navigationTitle("Time Logged")
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	class FakeAuthProvider: AuthProvider {
		func checkAuthState() -> User? { nil }
		func signIn(email: String, password: String, completion: @escaping SesionStoreResult) { }
		func signOut() throws { }
	}
	
	static var previews: some View {
		HomeView(viewModel: HomeScreenViewModel(timeslotsLoader: RemoteTimeslotsLoaderMock(store: MockStore()), userLoader: UserLoaderMock()))
			.environmentObject(SessionStore(authProvider: FakeAuthProvider()))
	}

	private class MockStore: TimeslotsStore {
		func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
			completion(.success(uniqueTimeslots))
		}
		func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
			completion(nil)
		}
	}

	private class UserLoaderMock: UserLoader {
		func getUser() -> User {
			User(uid: UUID().uuidString, email: "somteEmail@test.com", username: "Test", client: "Client")
		}
	}

	private class RemoteTimeslotsLoaderMock: TimeslotsLoader {
		var store: TimeslotsStore
		func getTimeslots(userID: String, completion: @escaping GetTimeslotsResult) {
			completion(.success(uniqueTimeslots))
		}
		init(store: TimeslotsStore) {
			self.store = store
		}
	}
}

var uniqueTimeslots: [TimeSlot] = {
	[
		uniqueTimeslot,
		uniqueTimeslot,
	]
}()

var uniqueTimeslot: TimeSlot = {
	TimeSlot(id: UUID().uuidString,
			 userId: UUID().uuidString,
			 clientId: Int.random(in: 0...100),
			 projectId: Int.random(in: 0...100),
			 date: Date(),
			 details:
				TimeSlotDetails(
					start: Date(),
					end: Date(),
					description: "some description"),
			 total: Int.random(in: 0...100))
	}()
