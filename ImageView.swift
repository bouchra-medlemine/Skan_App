/*
 * ImageView.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 03/04/2024
 *
 * Description: After choosing a photo and getting its predicted label, this view shows the results, some additional information, and a save button.
 */


import SwiftUI
import SwiftData
import UIKit



struct ImageView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @EnvironmentObject var appInfo: AppInformation
    
    // Retrieve the files saved in the database.
    @Query private var items: [File]
    
    @Binding var data: UIImage?
    @State var diagnosis: String
    @State private var showFolderNameAlert = false
    @State var newFolder: String = ""
    
    // Group the files in the database by their folders, and show the folder names to the user when choosing which existing folder to add a new scan to.
    var groupedFiles: [String: [File]] {
            Dictionary(grouping: items, by: { $0.folder })
    }
    

    var body: some View {

        // Display the image.
        List {
            
            Section {
                if let data = data {
                    Image(uiImage: data)
                        .resizable()
                        .scaledToFit()
                        .listRowSeparator(.hidden)
                        .clipShape(.rect(cornerRadius: 10))
                        .listRowBackground(Color.clear)
                }
            }
            
            // Show information about this diagnosis.
            if diagnosis == "Malignant" {
                MalignantInfoView()
            }
            else if diagnosis == "Benign" {
                BenignInfoView()
            }
            
        }
        
        
        
        // The save button.
        VStack {
            
            // If no folder name is available, show a folders list to choose from when the user clicks save.
            if appInfo.folder == "" {

                Menu("Save") {
                    // Show all the existing folders.
                    ForEach(groupedFiles.keys.sorted(), id: \.self) { folder in
                        Button(folder, action: {
                            if let data = data, let data = data.jpegData(compressionQuality: 0.8) {
                                saveScan(diagnosis: diagnosis, image: data, date: Date(), folder: folder)
                            }
                        })
                    }

                    // Show the option to save the scan in a new folder.
                    Button(action: {
                        showFolderNameAlert = true
                    }, label: {
                        Label("New Folder", systemImage: "plus.rectangle.fill")
                            .font(.largeTitle)
                    })

                }.alert(
                    Text("New Folder Name"),
                    isPresented: $showFolderNameAlert
                ) {
                    Button("Cancel", role: .cancel) {
                        // Do nothing when the user cancels.
                    }
                    
                    Button("OK") {
                        // After the new folder name is entered, save the scan to it..
                        if let data = data, let data = data.jpegData(compressionQuality: 0.8) {
                            saveScan(diagnosis: diagnosis, image: data, date: Date(), folder: newFolder)
                        }
                    }.fontWeight(.thin)
                    
                    TextField("Enter the folder name", text: $newFolder)
                        .foregroundColor(.color5)
                }
                .listRowBackground(Color.clear)
                .fontWeight(.bold)
                .padding(10)
                .background(.color1)
                .cornerRadius(7)
                .foregroundColor(.white)
                .fontDesign(.default)
            }

            
            // If a folder name is available (i.e., if the user chose the folder to add the scan to before scanning), save the scan to that folder when "save" is clicked.
            else {
                Button("Save") {
                    if let data = data, let data = data.jpegData(compressionQuality: 0.8) {
                        saveScan(diagnosis: diagnosis, image: data, date: Date(), folder: appInfo.folder)
                    }
                    dismiss()

                }.listRowBackground(Color.clear)
                 .fontWeight(.bold)
                 .padding(10)
                 .background(.color1)
                 .cornerRadius(7)
                 .foregroundColor(.white)
                 .fontDesign(.default)

            }
 
        }.padding(.bottom, 10)
    }
    
    
    // The following functions adds a new entry to the database.
    private func saveScan(diagnosis: String, image: Data, date: Date, folder: String) {
        print("******** Saving the scan ...")
        let item = File(diagnosis: diagnosis, image: image, date: date, folder: folder)
        context.insert(item)
        dismiss()
        print("******** Successfully saved the scan ...")
        
        appInfo.folder = ""
    }
 
    
}


