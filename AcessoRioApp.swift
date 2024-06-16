//
//  AcessoRioApp.swift
//  AcessoRio
//
//  Created by Alexandre César Brandão de Andrade on 10/04/24.
//

import SwiftUI

@main
struct AcessoRioApp: App {
    @StateObject private var viewModel = ViewModel() // Create the ViewModel instance

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel) // Pass the ViewModel to ContentView
        }
    }
}
