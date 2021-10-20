//
//  FilledHomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct FilledHomeView: View {
    var body: some View {
        VStack{
            Spacer()
            Text("Project title")
            List{
                VStack{
                    ProgressView()
                }
            }
            Spacer()
        }
    }
}

struct FilledHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FilledHomeView()
    }
}
