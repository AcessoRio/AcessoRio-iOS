//
//  ReportIssueView.swift
//  AcessoRio
//
//  Created by Felipe Gameleira on 06/05/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct ReportIssueView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Adicionar Fotos")) {
                    if let firstImage = viewModel.images.first {
                        Image(uiImage: firstImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }

                Section {
                    Text("Localização: \(viewModel.locationManager.currentAddress ?? "Locating...")")
                }

                Section(header: Text("Selecione o problema")) {
                    List(IssueType.allCases, id: \.self) { type in
                        HStack {
                            Text(type.rawValue)
                            Spacer()
                            if type == viewModel.selectedType {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedType = type
                        }
                    }
                }

                Button("Salvar") {
                    viewModel.saveReport()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(viewModel.selectedType == nil || viewModel.images.isEmpty)
            }
            .navigationBarTitle("Registrar Problema", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}



//#Preview{
//    ReportIssueView()
//}
