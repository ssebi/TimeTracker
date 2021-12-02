//
//  Logo.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        HStack{
            Image("logo")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text("TIME")
            Text("TRACKER").bold()
        }
        .foregroundColor(.white)
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
