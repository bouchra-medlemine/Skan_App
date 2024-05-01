/*
 * HomeView.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 02/04/2024
 *
 * Description: This struct includes the tabview that switches between 3 views (the saved folders, the main view, and the user account).
 */


import SwiftUI
import AVKit



struct HomeView: View {
    
    // By default the second tab is selected (i.e., showing the ScanView)
    @State private var selection = 2

    var body: some View {
        
        // Display the tab view including 3 tabs ("Folders", "Scan", and "Settings")
        TabView(selection:$selection) {
            
            FoldersView(selectedTab: $selection)
                .tabItem() {
                    Image(systemName: "folder.fill")
                    Text("Saved")
            }
            .tag(1)
            
            ScanView().navigationBarHidden(true)
                .tabItem() {
                    Image(systemName: "camera.fill")
                    Text("Scan")
            }
            .tag(2)
            
            AccountView()
                .tabItem() {
                    Image(systemName: "person.fill")
                    Text("Account")
            }
            .tag(3)
            
        }
        .accentColor(.color1)
    
    }
}

