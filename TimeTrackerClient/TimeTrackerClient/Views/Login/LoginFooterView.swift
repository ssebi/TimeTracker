//
//  LoginFooterView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI

struct LoginFooterView: View {
    var body: some View {
        VStack{
            Spacer()
            Text("Forgot password?")
                .padding()
            Text("Register a new account")
        }
        .foregroundColor(.cGray)
    }
}

struct LoginFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFooterView()
    }
}
