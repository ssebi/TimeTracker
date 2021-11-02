//
//  Project.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct ProjectView: View {
    var body: some View {
        Section{
            VStack{
                HStack{
                    Text("Timetracker Project")
                        .font(.title2)
                    Spacer()
                }
                .padding()
                VStack{
                    HStack{
                        Text("13:00 - 14:00")
                        Spacer()
                        Text("Worked on UI elemnets")
                    }
                    HStack{
                        Text("13:00 - 14:00")
                        Spacer()
                        Text("Worked on xxx and yyy")
                    }
                    HStack{
                        Text("13:00 - 14:00")
                        Spacer()
                        Text("Bug fixing")
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

struct Project_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
