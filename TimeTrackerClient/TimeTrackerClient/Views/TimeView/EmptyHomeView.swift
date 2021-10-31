//
//  EmptyHomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct EmptyHomeView: View {
    @EnvironmentObject var userData: DataStore
    var body: some View {
        NavigationView{
            HStack{
                NavigationLink(destination: AddView()){
                    Text("+")
                        .padding()
                        .frame(width: 200, height: 100, alignment: .center)
                        .background(Color.cGreen)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .font(.largeTitle .bold())
                }
            }
        }
    }
}

struct EmptyHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHomeView()
    }
}
