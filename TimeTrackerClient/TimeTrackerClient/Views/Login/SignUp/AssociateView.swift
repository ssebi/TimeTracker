//
//  AssociateView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 09.03.2022.
//

import SwiftUI
import TimeTrackerAuth
import TimeTrackerCore

struct AssociateView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel

    var body: some View {
        VStack{
            Text("Fill in your company email")
                .foregroundColor(.cBlack)
                .font(Font.custom("Avenir-Light", size: 20.0))
                .padding()

            Text("\(viewModel.errrorMessage)")
                .foregroundColor(.red)
                .font(Font.custom("Avenir-Light", size: 20))
                .padding()
                .frame(width: UIScreen.main.bounds.width - 60, alignment: .center)

            HStack {
                Image(systemName: "person.fill")
                TextField("E-mail", text: $viewModel.companyEmail)
                    .foregroundColor(.cBlack)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .frame(width: UIScreen.main.bounds.width - 110, alignment: .center)
                    .onTapGesture {
                        viewModel.errrorMessage = ""
                    }
            }.underlineTextField()
                .padding()
            Spacer()
            Button(action: {
                viewModel.checkCompany() { result in
                    print("result = >> company ", result)
                }
            }) {
                NavigationLink("Next step", destination: SignUpView(viewModel: viewModel))                    .font(Font.custom("Avenir-Light", size: 25))
                    .frame(maxWidth: .infinity, alignment: .center)
            }.buttonStyle(SubmitButton())
        }
        if viewModel.isLoading {
            ProgressIndicator()
        }
    }
}

struct AssociateView_Previews: PreviewProvider {
    static var previews: some View {
        AssociateView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider()), userLoader: FirebaseUserLoader()))
    }
}
