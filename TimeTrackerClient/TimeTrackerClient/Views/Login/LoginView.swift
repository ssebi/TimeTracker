//
//  LoginView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 12.10.2021.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
	var body: some View {
		ZStack {
			ScrollView(showsIndicators: false) {
				VStack {
					Image("timeTrackerIcon")
						.resizable()
						.frame(width: 200, height: 230, alignment: .center)

					Text("Time Tracker")
						.padding()
						.foregroundColor(Color.cBlack)
                        .font(Font.custom("Avenir-Light", size: 60.0))

					Spacer()

					Group {
                        Text("\(viewModel.errrorMessage)")
                            .foregroundColor(.red)
                            .font(Font.custom("Avenir-Light", size: 30))
                            .padding()
                        TextField("E-mail", text: $viewModel.username)
							.padding()
							.background(Color.cGray)
							.cornerRadius(5.0)
							.accentColor(.white)
							.autocapitalization(.none)
							.disableAutocorrection(true)
                            .onTapGesture {
                                viewModel.errrorMessage = ""
                            }

                        SecureField("Password", text: $viewModel.password)
							.padding()
							.background(Color.cGray)
							.accentColor(.white)
							.cornerRadius(5.0)
                            .onTapGesture {
                                viewModel.errrorMessage = ""
                            }
					}
					.padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
					Spacer()
                    Section {
                        Button(action: {
                            viewModel.signIn()
                        }) {
                            Text("Login")
                                .font(Font.custom("Avenir-Light", size: 25))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(width: UIScreen.main.bounds.width - 45, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(LinearGradient.loginButton)
                        .cornerRadius(5)
                        .padding(.bottom, 50)
                    }
				}
			}
            .frame(maxWidth: .infinity)

			if viewModel.isLoading {
				ProgressIndicator()
			}
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
        LoginView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
	}
}
