//
//  LoginViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 24.11.2021.
//

import Foundation
import SwiftUI

public class LoginViewModel: ObservableObject {
    @Published var isLoading = true

    init(){
        
        isLoading = false
    }
}

public class LoginViewModel: ObservableObject {
    @Published var isLoading = false

    init(){
        isLoading = true
    }
}
