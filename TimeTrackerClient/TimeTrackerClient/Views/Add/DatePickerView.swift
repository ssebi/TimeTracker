//
//  DatePicker.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var startEndDate: StartEndDate
    @Binding var timeInterval: DateComponents
    @State var dateRange: ClosedRange<Date>
    
    var body: some View {
        VStack {
            DatePicker(
                "Start",
                selection: $startEndDate.start,
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute]
            )
            DatePicker(
                "End",
                selection: $startEndDate.end,
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute]
            )
            HStack{
                Text("Total h:\(timeInterval.hour ?? 0)  - m:\(timeInterval.minute ?? 0)")
                Spacer()
            }
        }
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
