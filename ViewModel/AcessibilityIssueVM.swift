//
//  AcessibilityIssueVM.swift
//  AcessoRio
//
//  Created by Alexandre César Brandão de Andrade on 10/04/24.
//

import Foundation

// View model to manage the issues and map annotations
class AccessibilityIssuesViewModel: ObservableObject {
    @Published var issues: [AccessibilityIssue] = []
    // Load issues from annotations and convert to CSV
}
