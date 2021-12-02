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

            LoginFooterView()
            
            ScrollView(showsIndicators: false) {
                VStack{

                    Spacer()
                    LogoView()
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white)
                            .frame(width: UIScreen.main.bounds.width - 65, height: UIScreen.main.bounds.height / 2)
                            .shadow(color: .gray, radius: 30, x: 10, y:0)

                        LoginFormView(viewModel: viewModel)
                    }
                    .offset(y: -keyboardResponder.currentHeight*0.5)
                    Spacer()

                }
                .offset(y: UIScreen.main.bounds.height / 10)
            }


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
