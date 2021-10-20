//
//  HomeView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 18.10.2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            HStack(){
                Text("Today")
                    .padding()
                    .frame(alignment: .leading)
                    .font(.largeTitle)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(Date(), style:  .date)
                    .padding()
                    .font(.subheadline)
            }
            Spacer()
            HStack{
                Button("+"){}
                .buttonStyle(AddButton())
            }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
