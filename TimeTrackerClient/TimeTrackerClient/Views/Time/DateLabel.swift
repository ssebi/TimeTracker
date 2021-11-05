//
//  DateLabel.swift
//  TimeTrackerClient
//
//  Created by VSebastian on 05.11.2021.
//

import SwiftUI

struct DateLabel: View {
	let text: String
	let date: Date
	let style: Text.DateStyle

	var body: some View {
		HStack {
			Text(text)
			Text(date, style: style)
				.fontWeight(.medium)
		}
	}
}
