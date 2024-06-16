//
//  LocationManager.swift
//  AcessoRio
//
//  Created by Alexandre César Brandão de Andrade on 07/05/24.
//

import Foundation
import CoreLocation

// Location manager to handle getting location and converting to address
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

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
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
