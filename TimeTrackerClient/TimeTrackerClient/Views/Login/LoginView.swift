//
//  LoginView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 12.10.2021.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    @ObservedObject var keyboardResponder = KeyboardResponder()

    var body: some View {
        ZStack {
            VStack{
                Rectangle()
                    .fill(LinearGradient.gradientBackground)
                Rectangle()
                    .fill(Color.white)
            }.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white)
                        .frame(width: UIScreen.main.bounds.width - 65, height: UIScreen.main.bounds.height / 2)
                        .shadow(color: .gray, radius: 30, x: 10, y:0)
                    VStack {
                        LogoView()

                        Spacer()

                        Text("Login with your")
                        HStack{
                            Text("TIME")
                            Text("TRACKER").bold()
                        }
                        Text("account")
                            .padding()
                            .foregroundColor(Color.cBlack)
                            .font(Font.custom("Avenir-Light", size: 30.0))
                            //.offset(x: 0, y: 20)

                        LoginFormView(viewModel: viewModel)
                    }
                    .offset(y: -keyboardResponder.currentHeight*0.5)
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
