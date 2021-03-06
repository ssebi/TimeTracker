//
//  LoginView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 12.10.2021.
//

import SwiftUI
import TimeTrackerAuth

struct LoginView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .fill(LinearGradient.gradientBackground)
                Rectangle()
                    .fill(Color.cWhite)
            }.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        Spacer()
                        
                        LogoView()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.loginCard)
                                .frame(width: UIScreen.main.bounds.width - 65, height: (UIScreen.main.bounds.height / 2) + 70)
                                .shadow(color: Color.black.opacity(0.2), radius: 15, x: 5, y:5)
                            
                            LoginFormView(viewModel: viewModel)
                        }
                    }
                    .offset(y: -keyboardResponder.currentHeight*0.5)
                    Spacer()
                    
                }
                .offset(y: UIScreen.main.bounds.height / 10)
                
                LoginFooterView()
                    .offset(y: 60)
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
