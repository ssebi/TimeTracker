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
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from: startComponents)!
        ...
        calendar.date(from: endComponents)!
    }()
    
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
                       timeInterval: .constant(DateComponents()))
    }
}
