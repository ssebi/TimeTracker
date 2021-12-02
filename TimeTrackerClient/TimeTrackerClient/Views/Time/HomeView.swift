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
    @State private var showConfirmation = false

	@ObservedObject private(set) var viewModel: HomeScreenViewModel

	var body: some View {
		NavigationView {
            ZStack{
                Rectangle()
                    .fill(Color.projectViewBackground)
                    .ignoresSafeArea()
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
                                showConfirmation = true
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
                                        .gradientForeground(colors: [.gradientTop, .gradientBottom])
                                        .font(.system(size: 30))
                                }
                            })
                ).alert(isPresented: $showConfirmation){
                    Alert(
                        title: Text("Log out"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Yes"), action: {
                            session.signOut()
                        }),
                        secondaryButton: .cancel(Text("Cancel"), action: {
                        })
                    )
                }
                .navigationTitle("Time Logged")
            }
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
			 clientName: "Some clinet",
			 projectName: "Some project",
			 date: Date(),
			 details:
				TimeSlotDetails(
					start: Date(),
					end: Date(),
					description: "some description"),
			 total: Int.random(in: 0...100))
	}()
