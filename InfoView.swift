/*
 * InfoView.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 03/04/2024
 *
 * Description: This file contains BenignInfoView and MalignantInfoView which show information about benign and malignant lesions, respectively.
 */


import SwiftUI



struct BenignInfoView: View {
    
    let images = ["Benign_1", "Benign_2", "Benign_3"]
    
    var body: some View {
 
        // Display the diagnosis
        Text("Benign")
            .font(.system(
                size: 30,
                weight: .regular,
                design: .default)
            )
            .fontWeight(.heavy)
            .foregroundColor(.color2)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 20)
            .listRowBackground(Color.clear)
        
        
        // Display some information about this diagnosis
        Section(header: Text("General information")) {
            Text("Benign skin lesions are non-cancerous lumps or bumps such as moles, cysts, warts or skin tags. They can be removed from the skin using chemical and surgical procedures.")
                .fontDesign(.default)
        }
    
            
        // Show similar lesions
        Section(header: Text("Images of benign lesions")) {
            GeometryReader { geometry in
                TabView {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .frame(maxWidth: .infinity)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                
            }.frame(height: 300)
            
        }.listRowBackground(Color.clear)
        

        // Add a "More info" link
        Section(header: Text("More Info")) {
            Link("NHS Website", destination: URL(string: "https://bnssg.icb.nhs.uk/directory/benign-skin-lesions/")!)
            .fontWeight(.bold)
            .foregroundColor(.color1)
        }
    }
    
}



struct MalignantInfoView: View {
        
    let images = ["Malignant_1", "Malignant_2", "Malignant_3"]
    
    var body: some View {
        
        // Display the diagnosis
        Text("Malignant")
            .font(.system(
                size: 30,
                weight: .regular,
                design: .default)
            )
            .fontWeight(.heavy)
            .foregroundColor(.color2)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 20)
            .listRowBackground(Color.clear)
        
        
        // Display some information about this diagnosis
        Section(header: Text("General information")) {
            Text("Malignant skin lesions are cancerous lesions that can be classified as melanoma or non-melanoma. Melanoma is the most dangerous skin cancer type and is more common in older people, but young people can also get it.")
                .fontDesign(.default)
        }
        
        
        // Show similar lesions
        Section(header: Text("Images of malignant lesions")) {
            GeometryReader { geometry in
                TabView {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .frame(maxWidth: .infinity)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                
            }.frame(height: 300)
            
        }.listRowBackground(Color.clear)
        
        
        // Add a "More info" link
        Section(header: Text("More Info")) {
            Link("Cancer Research UK", destination: URL(string: "https://www.cancerresearchuk.org/about-cancer/skin-cancer")!)
                .fontWeight(.bold)
                .foregroundColor(.color1)
        }
        
    }
    
}

 
