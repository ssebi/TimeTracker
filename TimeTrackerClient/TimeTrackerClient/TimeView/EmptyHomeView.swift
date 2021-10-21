//
//  EmptyHomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct EmptyHomeView: View {
    var body: some View {
        HStack{
            Button("+"){}
            .buttonStyle(AddButton())
        }
    }
}

struct EmptyHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHomeView()
    }
}
