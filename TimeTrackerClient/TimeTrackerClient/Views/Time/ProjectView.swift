//
//  Project.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import SwiftUI

struct ProjectView: View {
    let timeslot: TimeSlot

    var body: some View {
        VStack{
            HStack{
                Text("\(timeslot.projectName)")
                    .font(Font.custom("Avenir-Next", size: 20) .weight(.bold))
                Spacer()
                DateLabel(text: "", date: timeslot.date, style: .date)
            }
            .padding()

            HStack{
                VStack(alignment: .leading, spacing: 2){
                    Text("Start time")
                    DateLabel(text: "", date: timeslot.details.start, style: .time)
                }
                Spacer()
                Image(systemName: "clock")
                Spacer()
                VStack(alignment: .trailing, spacing: 2){
                    Text("End time")
                    DateLabel(text: "", date: timeslot.details.end, style: .time)
                }
            }
            .font(Font.custom("Avenir-Light", size: 20) .weight(.bold))
            .padding([.bottom, .trailing, .leading])

            HStack{
                Text("Time period")
                Spacer()
                Text("\(timeslot.total)")
            }
            .padding([.trailing, .leading])
            .font(Font.custom("Avenir-Light", size: 15))

            VStack{
                Text("Task description")
                    .font(Font.custom("Avenir-Next", size: 15))
                Text("\(timeslot.details.description)")
            }
            .padding([.bottom, .trailing, .leading])

        }
        .frame(maxWidth: .infinity, alignment: .center)
        .cornerRadius(10)
        .background(Color.projectView)
        .foregroundColor(.cBlack)
        .modifier(CardModifier())
        .foregroundColor(.white)
    }
}

struct Project_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(timeslot: TimeSlot(id: "", userId: "", clientName: "Some Name", projectName: "Some project", date: Date(), details: TimeSlotDetails(start: Date(), end: Date(), description: ""), total: 1))
            .previewLayout(.sizeThatFits)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 10, y: 10)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
    }

}
