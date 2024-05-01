/*
 * LoginView.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 02/04/2024
 *
 * Description: If the user is already logged in, this view will redirect to the main app view, otherwise it shows a sign-in view.
 */


import SwiftUI
import AVKit
import AuthenticationServices



struct ContentView: View {

    // Read the user id from the device storage
    @AppStorage("userId") var userId: String = ""
    
    var body: some View {
        
        // If the user has not signed in yet, show the SignIn view.
        if userId.isEmpty {
            SignInView()
        } else {
            HomeView()
        }
    }
}


struct SignInView: View {
    
    // colorSheme is used to check if the device is in dark mode.
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("userId") var userId: String = ""

    
    var body: some View {
        
        NavigationView {

            VStack {
                    
                // Display the app logo and name.
                Image("Skan_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width:300, height:300)
                    .clipShape(.rect(cornerRadius: 10))
                
                Text("Skan")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.default)
                    .font(.largeTitle)
                    .foregroundColor(.color2)
                    .padding(.bottom, 70)
                
                
                // Create a sign in with apple button.
                SignInWithAppleButton(.signIn) { request in
                    
                } onCompletion: { result in
                    
                    switch result {
                        // If the request was successful, save the user credentials (userID and firstName)
                        case .success(let auth):
                            switch auth.credential {
                                case let credential as ASAuthorizationAppleIDCredential:
                                    
                                    // Save userID in UserDefaults
                                    userId = credential.user

                                default:
                                    break
                            }
                        
                        // If the request fails, print the error.
                        case .failure(let error):
                            print(error)
                    }
                    
                }
                .signInWithAppleButtonStyle(
                    // Adjust the button appearance when the device is in light or dark mode.
                    colorScheme == .dark ? .white: .black
                )
                .frame(height: 50)
                .frame(width: 200)
                .padding()
                .cornerRadius(7.0)
                
            }
        }.navigationBarHidden(true)
    }
}




 
