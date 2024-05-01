/*
 * ScanView.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 02/04/2024
 *
 * Description: This is the main view of the app.
 */


import UIKit
import SwiftUI
import CoreML
import Vision



struct ScanView: View {
    
    // The two variables below are used to know if the user chose to take a photo or upload a photo.
    @State private var showPhotoLibrary = false
    @State private var showCamera = false
    
    
    // The skin lesion image and the prediction will be passed to ImageView
    @State private var image: UIImage?
    @State private var prediction: String = "None"
    @State private var imageWasClassified = false
    
    
    // Pages explain to the user how the app works in three steps.
    let slides = [
        ["Illustration_1", "1.square.fill", "Import a photo", "Take a photo focussing on the skin lesion"],
        ["Illustration_2", "2.square.fill", "AI model predicts", "The photo gets classified as benign or malignant"],
        ["Illustration_3", "3.square.fill", "Receive diagnosis", "Get information regarding the diagnosis and save it"]
    ]
    
    
    // dotAppearance is used to style the dots in the slideshow that shows the pages
    private let dotAppearance = UIPageControl.appearance()
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                // The title text
                Text("Diagnose Skin Abnormalities With AI")
                    .font(.system(
                        size: 30,
                        weight: .light,
                        design: .default)
                    )
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color_2"))
                    .padding(.horizontal, 20)
                    .lineSpacing(13)
                
                
                // Show the pages in a slideshow
                GeometryReader { geometry in
                    
                    TabView {
                        ForEach(slides, id: \.self) { slide in
                            VStack {
                                // Display the page image
                                Image("\(slide[0])")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:250, height:250)
                                    .cornerRadius(7)
                                
                                // Display the page title
                                HStack {
                                    Image(systemName: "\(slide[1])")
                                        .foregroundColor(.color2)
                                        .font(.system(
                                            size: 33)
                                        )
                                    Text(slide[2]).font(.title)
                                }.padding(.bottom, 10)
                                
                                // Display the page description
                                Text(slide[3]).font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .never))
                    .background(.gray.opacity(0.15))
                    .padding(.horizontal, 20)
                    .cornerRadius(50)
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear {
                        dotAppearance.currentPageIndicatorTintColor = UIColor(.color3)
                        dotAppearance.pageIndicatorTintColor = .lightGray
                    }
                    
                    
                }.frame(height: 430)
                    .padding(.vertical, 50)
                
                

                // The "Take photo" and "Upload photo" buttons
                HStack {
                    Button(action: {
                        self.showCamera = true
                        print("Showing camera")
                    }, label: {
                        Text("Take photo")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Color("Color_1"))
                            .cornerRadius(7)
                            .foregroundColor(.color4)
                    }).padding(.trailing, 30)
                     
                    
                    Button(action: {
                        self.showPhotoLibrary = true
                    }, label: {
                        Text("Upload photo")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Color("Color_1"))
                            .cornerRadius(7)
                            .foregroundColor(.color4)
                    })

                }.padding(.bottom, 30)
               
                
            }.navigationBarItems(trailing: NavigationLink("", destination: ImageView(data: $image, diagnosis: prediction), isActive: $imageWasClassified))
             .sheet(isPresented: $showPhotoLibrary) {
                 ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, prediction: self.$prediction, imageWasClassified: self.$imageWasClassified)
             }.sheet(isPresented: $showCamera) {
                 ImagePicker(sourceType: .camera, selectedImage: self.$image, prediction: self.$prediction, imageWasClassified: self.$imageWasClassified)
             }
        }
        
    }
    
}





