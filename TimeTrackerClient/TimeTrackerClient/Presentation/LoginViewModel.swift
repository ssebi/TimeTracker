//
//  LoginViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 24.11.2021.
//

import Foundation
import SwiftUI

public class LoginViewModel: ObservableObject {
    @State var username: String = ""
    @State var password: String = ""
    @Published var isLoading = true

    init(){
        isLoading = false
    }
}
