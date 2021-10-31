//
//  FilledHomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct FilledHomeView: View {
    @State var showView = false
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ProjectView()
                    ProjectView()
                    ProjectView()
                    ProjectView()
                }
                .listStyle(.grouped)
            }
            .navigationBarItems(
                  trailing: Button(action: {}, label: {
                     NavigationLink(destination: AddView()) {
                          Text("")
                     }
                  }))
        }
    }
}

struct FilledHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FilledHomeView()
    }
}
