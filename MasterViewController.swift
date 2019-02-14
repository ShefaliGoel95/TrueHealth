//
//  MasterViewController.swift
//  Prancercise Tracker
//
//  Created by Shefali Goel on 12/02/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class MasterViewController: UITableViewController {
    
    private let authorizeHealthKitSection = 2
    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
    
    // MARK: - UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == authorizeHealthKitSection {
            authorizeHealthKit()
        }
    }
}