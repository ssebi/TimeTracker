//
//  LoginFooterView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI

struct LoginFooterView: View {
    @State var showAlert = false

    var body: some View {
        VStack {
            Spacer()
            Button("Forgot password?") {
                showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Coming soon"), message: Text("This functionality is under development"), dismissButton: .default(Text("Got it!")))
                    }
                    .padding()
            Button("Create a new account") {
                showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Coming soon"), message: Text("This functionality is under development"), dismissButton: .default(Text("Got it!")))
                    }
        }
        .padding()
        .foregroundColor(.cGray)
    }
}

struct LoginFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFooterView()
    }
}
