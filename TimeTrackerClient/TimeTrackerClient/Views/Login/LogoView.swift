//
//  Logo.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack{
            Image("logo")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text("time")
            Text("TRACKER").bold()
        }
        .foregroundColor(.white)
        .font(Font.custom("Avenir-Light", size: 35.0))
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
