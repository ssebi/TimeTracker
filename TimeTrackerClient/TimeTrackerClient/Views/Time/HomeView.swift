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

	var addView: () -> AddView

    @ObservedObject private(set) var viewModel: HomeScreenViewModel

    var body: some View {
        ZStack{
            NavigationView {
                ZStack{
                    Rectangle()
                        .fill(Color.projectViewBackground)
                        .ignoresSafeArea()

                    ScrollView {
                        ForEach(viewModel.timeslots) { timeslot in
                            ProjectView(timeslot: timeslot)
                                .padding([.trailing, .leading, .top])
                        }
                    }

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(
                                action: {},
                                label: {
                                    NavigationLink(
                                        destination:
                                            addView()
                                    ) {
                                        Text("+")
                                            .font(.system(.largeTitle))
                                            .frame(width: 77, height: 70)
                                            .foregroundColor(Color.white)
                                            .padding(.bottom, 7)
                                    }

                                })
                                .background(LinearGradient.gradientBackground)
                                .cornerRadius(38.5)
                                .padding()
                                .shadow(color: Color.black.opacity(0.3),
                                        radius: 3,
                                        x: 3,
                                        y: 3)
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
}

struct HomeView_Previews: PreviewProvider {
    class FakeAuthProvider: AuthProvider {
        func checkAuthState() -> User? { nil }
        func signIn(email: String, password: String, completion: @escaping SesionStoreResult) { }
        func signOut() throws { }
    }

	static var previews: some View {
		HomeView(
			addView: { AddScreenUIComposer.makeAddScreen(clientsLoader: ClientLoaderMock(store: MockClientsStore()),
														 timeslotsPublisher: TimeSlotsPublisherMock(store: MockStore()),
														 userLoader: UserLoaderMock()) },
			viewModel: HomeScreenViewModel(timeslotsLoader: RemoteTimeslotsLoaderMock(store: MockStore()),
										   userLoader: UserLoaderMock())
		)
			.environmentObject(SessionStore(authProvider: FakeAuthProvider()))
    }

	private class MockClientsStore: ClientsStore {
		func getClients(completion: @escaping GetClientsResult) { }
	}
	private class ClientLoaderMock: ClientsLoader {
		var store: ClientsStore
		init(store: ClientsStore) {
			self.store = store
		}
		func getClients(completion: @escaping (Result<[Client], Error>) -> Void) {
			completion(.success([]))
		}
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
	private class TimeSlotsPublisherMock: TimeSlotsPublisher {
		var store: TimeslotsStore
		init(store: TimeslotsStore) {
			self.store = store
		}
		func addTimeSlot(_ timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
			completion(nil)
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
