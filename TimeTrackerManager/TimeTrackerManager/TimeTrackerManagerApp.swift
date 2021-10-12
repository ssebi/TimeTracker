//
//  TimeTrackerManagerApp.swift
//  TimeTrackerManager
//
//  Created by Sebastian Vidrea on 11.10.2021.
//

import SwiftUI
import Firebase

@main
struct TimeTrackerManagerApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
