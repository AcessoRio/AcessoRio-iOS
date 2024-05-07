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
    @State private var images: [UIImage] = []
    @State private var selectedType: IssueType?
    @StateObject var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Adicionar Fotos")) {
                    Button(action: {
                        // Action to take or pick a photo
                    }) {
                        if images.isEmpty {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        } else {
                            Image(uiImage: images.first!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        }
                    }
                }

                Section {
                    Text("Localização: \(locationManager.currentAddress ?? "Locating...")")
                }

                Section(header: Text("Selecione o problema")) {
                    List(IssueType.allCases, id: \.self) { type in
                        HStack {
                            Text(type.rawValue)
                            Spacer()
                            if type == selectedType {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedType = type
                        }
                    }
                }

                Button("Salvar") {
                    saveReport()
                }
                .disabled(selectedType == nil || images.isEmpty)
            }
            .navigationBarTitle("Registrar Problema", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                self.locationManager.requestLocationAccess()
            }
        }
    }

    func saveReport() {
        // Function to save the data to a CSV file
        guard let selectedType = selectedType, let location = locationManager.lastKnownLocation else {
            return
        }
        let csvLine = "\(selectedType.rawValue),\(location.coordinate.latitude),\(location.coordinate.longitude)\n"
        // Save this CSV line to a file
        print("Data to save:", csvLine)
        
        // Close the view
        presentationMode.wrappedValue.dismiss()
    }
    
    
}

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation?
    @Published var currentAddress: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    func requestLocationAccess() {
        print("Solicitando permissão para localização.")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Permissão concedida para usar a localização.")
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                print("Serviços de localização não estão habilitados.")
            }
        case .denied, .restricted:
            print("Acesso à localização negado ou restrito.")
        case .notDetermined:
            print("Permissão de localização ainda não determinada.")
        @unknown default:
            fatalError("Status de autorização desconhecido")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location
            reverseGeocode(location: location)
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let err = error {
                print("Erro ao realizar geocodificação reversa: \(err.localizedDescription)")
                self.currentAddress = "Erro ao encontrar endereço."
            } else if let placemarks = placemarks, let placemark = placemarks.first {
                // Montar o endereço em um formato legível
                let addressArray = [
                    placemark.thoroughfare, // Rua
                    placemark.subThoroughfare, // Número
                    placemark.locality, // Cidade
                    placemark.administrativeArea, // Estado
                    placemark.postalCode // CEP
                ]
                self.currentAddress = addressArray.compactMap { $0 }.joined(separator: ", ")
                print("Endereço atualizado: \(self.currentAddress ?? "Endereço indisponível")")
            } else {
                print("Nenhum placemark encontrado.")
                self.currentAddress = "Endereço não disponível."
            }
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Falha ao receber localizações: \(error.localizedDescription)")
    }
}


#Preview{
    ReportIssueView()
}
