/*
 * CI601_ProjectApp.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 02/04/2024
 *
 */


import SwiftUI
import SwiftData



@main
struct CI601_ProjectApp: App {
    
    @StateObject var appInfo = AppInformation()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appInfo)
        }
        .modelContainer(for: File.self)
    }
}


// Define the ObservableObject that will be used to pass data between the views.
class AppInformation: ObservableObject {
    @Published var folder = ""
}


