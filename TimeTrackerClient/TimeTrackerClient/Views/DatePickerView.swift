//
//  DatePicker.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 25.10.2021.
//

import SwiftUI

struct DatePickerView: View {
    @EnvironmentObject var startEndDate: StartEndDate
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
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
                selection:  $startEndDate.end,
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute]
            )
            
            
            let timeInterval = Calendar.current.dateComponents([.hour, .minute], from: startEndDate.start, to: startEndDate.end)
            HStack{
                Text("Total h:\(timeInterval.hour!)  - m:\(timeInterval.minute!)")
                Spacer()
            }
        }
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}
