//
//  WorkoutsTableViewController.swift
//  Prancercise Tracker
//
//  Created by Shefali Goel on 12/02/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//


//MARK::- MODULES
import UIKit
import HealthKit

//MARK::- CLASS
class WorkoutsTableViewController: UITableViewController {
    
    //MARK::- PROPERTIES
    private enum WorkoutsSegues: String {
        case showCreateWorkout
        case finishedCreatingWorkout
    }
    private var workouts: [HKWorkout]?
    private let prancerciseWorkoutCellID = "PrancerciseWorkoutCell"
    lazy var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadWorkouts()
    }
    
    //MARK::- FUNCTIONS
    func reloadWorkouts() {
        
        //load the workouts from the WorkoutDataStore
        WorkoutDataStore.loadPrancerciseWorkouts { (workouts, error) in
            self.workouts = workouts
            self.tableView.reloadData()
        }
    }
}


// MARK: - TABLEVIEW DATASOURCE
extension WorkoutsTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workouts = workouts else {
            fatalError("""
      CellForRowAtIndexPath should \
      not get called if there are no workouts
      """)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            prancerciseWorkoutCellID, for: indexPath)
        let workout = workouts[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: workout.startDate)
        if let caloriesBurned =
            workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) {
            let formattedCalories = String(format: "CaloriesBurned: %.2f",
                                           caloriesBurned)
            
            cell.detailTextLabel?.text = formattedCalories
        } else {
            cell.detailTextLabel?.text = nil
        }
        return cell
    }
}
