//
//  FilledHomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct FilledHomeView: View {
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
            .toolbar {
                Button("+"){ }
                .buttonStyle(AddBarButton())
            }
        }
        .navigationBarItems(trailing: AddView())
    }
}

struct FilledHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FilledHomeView()
    }
}
