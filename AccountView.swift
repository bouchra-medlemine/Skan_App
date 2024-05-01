/*
 * AccountView.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 03/04/2024
 *
 * Description: The user account page, including "help", "log out" and "delete account" buttons.
 */


import SwiftUI
import UIKit
import AuthenticationServices
import MessageUI


struct AccountView: View {
    
    @Environment(\.modelContext) private var context
    @State private var confirmDelete = false
    @State private var confirmLogOut = false


    var body: some View {
           
        NavigationStack {
            
            // The user icon
            Image(systemName: "person.circle.fill")
                .foregroundColor(.gray)
                .font(.system(
                    size: 100)
                )
            
            Spacer()
            
            // The help button
            NavigationLink {
                HelpView()
            } label: {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.color4)
                        .font(.system(
                            size: 18)
                        )
                    
                    Text("Help")
                        .font(.system(
                            size: 20))
                        .foregroundColor(.color4)
                        .fontDesign(.default)
                }
                .padding(10)
                .background(.color1)
                .cornerRadius(7)
                .cornerRadius(7)
            }
          
            
            // Sign out button
            Button(action: {
                confirmLogOut = true
            }, label: {
                HStack {
                    Image(systemName: "arrow.backward.square.fill")
                        .foregroundColor(.color4)
                        .font(.system(
                        size: 18)
                        )
                    
                    Text("Log out")
                        .foregroundColor(.color4)
                   .font(.system(size: 20))
                   .fontDesign(.default)
                    
                }
                .padding(10)
                .background(.color1)
                .cornerRadius(7)
                .cornerRadius(7)
                 
            }).padding(.vertical, 70)
               .alert(isPresented: $confirmLogOut) {
                Alert(
                    title: Text("Log out"),
                    message: Text("Are you sure you want to log out"),
                    primaryButton: .cancel(),
                    secondaryButton: .default(Text("Yes"), action: logOut)
                )
            }
            
          
            // Account delete button
            Button(action: {
                confirmDelete = true
            }, label: {
                HStack {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.color4)
                        .font(.system(
                            size: 18)
                        )
                    
                    Text("Delete account")
                        .foregroundColor(.color4)
                        .font(.system(
                            size: 20))
                        .fontDesign(.default)
                    
                }
                .padding(10)
                .background(.color1)
                .cornerRadius(7)
                .background(.color1)
                .cornerRadius(7)
         
            }).alert(isPresented: $confirmDelete) {
                Alert(
                    title: Text("Delete account"),
                    message: Text("Are you sure you want to delete your account"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Yes"), action: deleteAccount)
                )
            }
            
            Spacer()
            
        }.navigationBarItems(trailing: NavigationLink("", destination: HelpView()))
    }
    
    
    
    // This function deletes the user sign in ID, which signs the user out.
    private func logOut() {
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    

    // This function deletes all the user data saved on the app.
     func deleteAccount() {
        UserDefaults.standard.removeObject(forKey: "userId")
        
        // Remove all the files associated with this user
        do {
            try context.delete(model: File.self)
        } catch {
            print("Failed to delete all data.")
        }
    }
    
    
   
            
}





