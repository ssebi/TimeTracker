//
//  Project.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct ProjectView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Project title")
                    .font(.title2)
                Spacer()
            }
            .padding()
            HStack{
                Text("13:00 - 14:00")
                Spacer()
                Text("Worked on this project")
            }
            .padding()
        }
        .padding()
    }
}

struct Project_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
