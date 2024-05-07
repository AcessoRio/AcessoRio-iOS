//
//  AccessibilityIssue.swift
//  AcessoRio
//
//  Created by Alexandre César Brandão de Andrade on 10/04/24.
//

import Foundation
import SwiftUI
import MapKit

// Model for the accessibility issue
struct AccessibilityIssue: Identifiable {
    let id = UUID()
    var type: IssueType
    var location: CLLocationCoordinate2D
    var description: DescriptionType
}

enum IssueType: String, CaseIterable {
    case unevenSidewalk = "Desnível e Irregularidades"
    case noAccessRamp = "Ausência de Rampa de Acesso"
    case noTactileSignage = "Ausência de Sinalização Tátil"
    case fixedObstacles = "Obstáculos Fixos"
}


enum DescriptionType: String, CaseIterable{
    case unevenSidewalk = "Calçadas com desníveis, buracos ou superfícies irregulares"
    case noAccessRamp = "Falta de rampas em locais estratégicos"
    case noTactileSignage = "Falta de pisos podotáteis para pessoas com deficiência visual"
    case fixedObstacles = "Árvores, poste ou lixeiras bloqueando passagem"
}

// Custom annotation for map issues
class AccessibilityAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let type: IssueType

    init(type: IssueType, coordinate: CLLocationCoordinate2D) {
        self.title = type.rawValue
        self.coordinate = coordinate
        self.type = type
    }
}
