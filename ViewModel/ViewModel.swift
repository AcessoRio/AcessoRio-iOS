//
//  ViewModel.swift
//  AcessoRio
//
//  Created by Alexandre César Brandão de Andrade on 06/06/24.
//

import Foundation
import SwiftUI
import CoreLocation

class ViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    @Published var selectedType: IssueType? // Ensure this is a variable and optional
    @Published var locationManager = LocationManager()
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    @Published var navigateToReportIssue = false

    func loadImage() {
        guard let inputImage = inputImage else { return }
        images.append(inputImage)
        // Update location after image is taken
        locationManager.startUpdatingLocation()
        navigateToReportIssue = true
    }

    func saveReport() {
        // Function to save the data to a CSV file
        guard let selectedType = selectedType, let location = locationManager.lastKnownLocation else {
            return
        }
        let csvLine = "\(selectedType.rawValue),\(location.coordinate.latitude),\(location.coordinate.longitude)\n"
        // Save this CSV line to a file
        print("Data to save:", csvLine)

        // Reset state after saving
        images.removeAll()
//        selectedType = nil
        inputImage = nil
        navigateToReportIssue = false
    }
}
