//
/*
 * DataItem.swift
 *
 * Author: Bouchra Mohamed Lemine
 * Date: 03/04/2024
 *
 * Description: This is the SwiftData model that defines the structure of the database.
 */

import Foundation
import SwiftData


@Model
class File {
    
    // Each entry contains a file id, diagnosis, photo of the lesion, the date and time at which the photo was taken, and the name of the folder the photo should be saved in.
    var id: String
    var diagnosis: String
    var image: Data?
    var date: Date
    var folder: String
    
    init(diagnosis: String, image: Data, date: Date, folder: String) {
        self.id = UUID().uuidString
        self.diagnosis = diagnosis
        self.image = image
        self.date = date
        self.folder = folder
    }
    
}




