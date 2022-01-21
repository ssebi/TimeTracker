//
//  DatePicker.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI
import TimeTrackerCore

struct DatePickerView: View {
    @Binding var startEndDate: StartEndDate
    @Binding var timeInterval: DateComponents
    @State var dateRange: ClosedRange<Date>
    
    var body: some View {
        VStack {
            Text("Start time")

            DatePicker(
                "",
                selection: $startEndDate.start,
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute]
            ).datePickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
                .labelsHidden()
                .padding(.bottom)
                .environment(\.locale, Locale(identifier: "en_GB"))

            Text("End time")

            DatePicker(
                "",
                selection: $startEndDate.end,
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute]
            ).datePickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "en_GB"))

            HStack{
                Text("Total duration")
                Spacer()
                Text("\(timeInterval.hour ?? 0) h: \(timeInterval.minute ?? 0) m")
                    .font(Font.custom("Avenir-Next", size: 25))
            }
            .padding(.top)

        }.font(Font.custom("Avenir-Light", size: 20))
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(startEndDate: .constant(StartEndDate(start: Date(), end: Date())),
                       timeInterval: .constant(DateComponents()),
					   dateRange: Date()...Date().addingTimeInterval(3600))
			.previewLayout(.sizeThatFits)
    }
}
