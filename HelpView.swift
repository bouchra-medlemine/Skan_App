/*
 * Help.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 03/04/2024
 *
 * Description: This view shows some information about the app to the user.
 */


import SwiftUI



struct HelpView: View {

    var body: some View {
        
        ScrollView {
            
            Text("Help")
                .fontWeight(.bold)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 40)
 
            Text("Skan is developed to be used by anyone concerned about a skin abnormality. This app diagnoses skin lesions using only AI. The model was trained on various skin conditions to be able to classify benign and malignant lesions, however, it may still make errors.\n\nFor more details or any questions, please contact us.")
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                .lineSpacing(10)
                .italic()
            
            
            // When the user clicks "Email Us", automatically compose an email in the gmail app.
            Button(action: {
                UIApplication.shared.open(
                    URL(string: "googlegmail://co?to=skan.app.help@gmail.com&subject=Message From Skan User&body=\("")") ?? URL(fileURLWithPath: "")
                )
            }, label: {
                Label("Email Us", systemImage: "paperplane.fill")
                    .foregroundColor(.color1)
                    .fontWeight(.bold)
                    .font(.title2)
            }).padding(.top, 20)
        }
    }
}

