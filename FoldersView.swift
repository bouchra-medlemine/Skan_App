/*
 * FoldersView.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 03/04/2024
 *
 * Description: This file creates the content of the folders tab in the app.
 */


import SwiftUI
import SwiftData



struct FoldersView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    // Retrieve the files in the database.
    @Query private var items: [File]
    
    @State private var showRenameAlert = false
    @State private var addingFile = false
    @State var folderName: String = "Default"
    @State private var newFolderName: String = ""
    @State private var oldFolderName: String = ""
    
    
    var groupedFiles: [String: [File]] {
            Dictionary(grouping: items, by: { $0.folder })
    }
     
    @EnvironmentObject var appInfo: AppInformation
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, hh:mm a"
        return formatter
    }()
    
 
    @Binding var selectedTab: Int
    
    
    var body: some View {
        
        // If the user has no saved scans, show the following:
        if items.count == 0 {
            
            VStack {
                Text("You do not have any saved scans")
                    .padding(.bottom, 20)
                
                Button("Start Scanning") {
                    selectedTab = 2 // Set the selected tab to the second tab (i.e., open ScanView)
                }.fontWeight(.bold)
            }

        }
        
        
        else {
            
            NavigationStack {
                List {
                    
                    // Display the folders in a list.
                    ForEach(groupedFiles.keys.sorted(), id: \.self) { folder in
                    
                        Section(header:
                          HStack {
                            Text("\(folder)").font(.headline)
                                .foregroundColor(.color1)
                                .font(.system(
                                    size: 30,
                                    weight: .regular,
                                    design: .default)
                                )
                            Spacer()
                            
                            // The folder menu ("Add", "Rename" and "Delete")
                            Menu {
                                // The rename button
                                Button {
                                    oldFolderName = folder
                                    // Show the textfield to get the new folder name
                                    showRenameAlert = true
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                        .font(.system(
                                            size: 30,
                                            weight: .regular,
                                            design: .default)
                                        )
                                }
                                
                                // The add button
                                Button {
                                    appInfo.folder = folder
                                    folderName = folder
                                    addingFile = true
                                    print("Adding a new file to " + folderName)
                                } label: {
                                    Label("Add", systemImage: "plus")
                                        .font(.system(
                                            size: 30,
                                            weight: .regular,
                                            design: .default)
                                        )
                                }
                                
                                // The delete button
                                Button {
                                    // Delete this folder
                                    deleteFolder(files: groupedFiles[folder] ?? [])
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .font(.system(
                                            size: 30,
                                            weight: .regular,
                                            design: .default)
                                        )
                                }
                        }
                        label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                        }.alert(
                            Text("Edit folder name"),
                            isPresented: $showRenameAlert
                        ) {
                            Button("Cancel", role: .cancel) {}
                            Button("OK") {
                                // Rename the folder with the given name.
                                renameFolder(files: groupedFiles[oldFolderName] ?? [], oldFolderName: oldFolderName, newFolderName: newFolderName)
                            }
                            TextField("New folder name", text: $newFolderName)
                        }
                            
                        }.textCase(.none)
                        ) {
                            // Show the folder list content (i.e., a summary of the files)
                            
                            ForEach(groupedFiles[folder] ?? []) { file in
                                
                                if let image = file.image, let uiImage = UIImage(data: image) {
                                    
                                    NavigationLink(destination: FileView(file: file, uiImage: uiImage)){
                                        HStack {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .frame(width: 100.0, height: 83.0)
                                            Spacer().frame(width: 40)
                                            Text(getDate(scan_date: file.date))
                                        }
                                   }
                                }
                            }
                        }
                    }
                }.navigationTitle("Saved Scans")
                    .fontDesign(.default)
                
            }.sheet(isPresented: $addingFile) {
                ScanView()
            }
 
        }
    }
    
    
    
    // This functions returns how long ago the file was created (e.g., 2 days ago)
    private func getDate(scan_date: Date) -> String {
        let current_date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: scan_date, to: current_date)

        if let years = components.year,
            let months = components.month,
            let days = components.day {
             
            if years > 0 {
                return "\(years) \(years == 1 ? "year" : "years") ago"
            }
            if months > 0 {
                return "\(months) \(months == 1 ? "month" : "months") ago"
            }
            if days > 0 {
                return "\(days) \(days == 1 ? "day" : "days") ago"
            }
            
            return "Today"
        }
        return dateFormatter.string(from: scan_date)
    }
    
    
    
    // Delete an entire folder
    private func deleteFolder(files: [File]) {
        for file in files {
            context.delete(file)
        }
    }
    
    
    
    // Rename a folder
    private func renameFolder(files: [File], oldFolderName: String, newFolderName: String) {
        
        print("Renaming \(oldFolderName) to \(newFolderName)")

        for file in files {
            file.folder = newFolderName
        }
        
        do {
            try context.save()
        } catch {
            print("!!!!!!! Could not update the database")
        }
    }
    
}






@MainActor
struct FileView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    
    @State var file: File
    @State var uiImage: UIImage
    @State private var confirmDelete = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, hh:mm a"
        return formatter
    }()

    var body: some View {
        
        // Show the lesion scan with information about it.
        List {
            
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .listRowSeparator(.hidden)
                .clipShape(.rect(cornerRadius: 10))
                .listRowBackground(Color.clear)
            

            Text(dateFormatter.string(from: file.date)).font(.system(
                size: 20,
                weight: .bold,
                design: .default)
            ).padding(.bottom, 30)
              .listRowBackground(Color.clear)
              .listRowSeparator(.hidden)
              .frame(maxWidth: .infinity, alignment: .center)
                    
            
            if file.diagnosis == "Malignant" {
                MalignantInfoView()
            }
            else {
                BenignInfoView()
            }

                
           // Add the delete and export buttons.
            HStack {

                Button(action: {
                    confirmDelete = true
                }, label: {
                    Text("Delete")
                }).buttonStyle(.borderedProminent)
                    .background(.color1)
                    .foregroundColor(.color4)
                    .fontWeight(.bold)
                    .cornerRadius(7)
                    .padding(.trailing, 30)
                    .alert(isPresented: $confirmDelete) {
                    Alert(
                        title: Text("Delete scan"),
                        message: Text("Are you sure you want to delete this scan"),
                        primaryButton: .cancel(),
                        secondaryButton: .default(Text("Yes")) {
                            deleteFile(file: file)
                        }
                    )
                }
                
                
                ShareLink("Export", item: render())
                    .buttonStyle(.borderedProminent)
                    .fontWeight(.bold)
                    .background(.color1)
                    .foregroundColor(.color4)
                    .cornerRadius(7)
                    .labelStyle(.titleOnly)
                    .imageScale(.large)
                    .symbolVariant(.fill)
           
                
            }.padding(.bottom, 50)
             .frame(maxWidth: .infinity, alignment: .center)
             .listRowBackground(Color.clear)
             
        }
        
    }
    
    
    
    // Export a scan into a PDF.
    func render() -> URL {

        // Choose the view to save in a PDF
        let renderer = ImageRenderer(content:
            PdfView(file: file, uiImage: uiImage)
        )

        // Set the PDF file name
        let url = URL.documentsDirectory.appending(path: "Skan_file.pdf")

        // 3: Start the rendering process
        renderer.render { size, context in
            // Set the PDF size
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }

            // Create a PDF page
            pdf.beginPDFPage(nil)

            // 7: Render the SwiftUI view data onto the page
            context(pdf)

            // End the pdf page and close it.
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
    
    
    
    // Deletes a file from a folder
    private func deleteFile(file: File) {
        context.delete(file)
        dismiss()
    }
    
}





