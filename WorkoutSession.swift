//
//  WorkoutSession.swift
//  Prancercise Tracker
//
//  Created by Shefali Goel on 12/02/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//


//MARK::- MODULES
import Foundation


//MARK::- ENUMERATIONS
enum WorkoutSessionState {
    case notStarted
    case active
    case finished
}

//MARK::- CLASS
//used to store data related to the current PrancerciseWorkout being tracked.
class WorkoutSession {
    
    //MARK::- PROPERTIES
    private (set) var startDate: Date!
    private (set) var endDate: Date!
    
    var state: WorkoutSessionState = .notStarted
    var intervals: [PrancerciseWorkoutInterval] = []
    
    func start() {
        startDate = Date()
        state = .active
    }
    
    //FOR WORKOUT WHICH IS NOT COMPOSED OF INTERVALS
//    func end() {
//        endDate = Date()
//        state = .finished
//    }

    func end() {
        endDate = Date()
        addNewInterval() //When you finish a Prancercise session, a new interval will get added to array.
        state = .finished
    }
    
    
    //FOR WORKOUT WHICH IS NOT COMPOSED OF INTERVALS
//    func clear() {
//        startDate = nil
//        endDate = nil
//        state = .notStarted
//    }
    
    
    func clear() {
        startDate = nil
        endDate = nil
        state = .notStarted
        intervals.removeAll()
    }
    
    private func addNewInterval() {
        let interval = PrancerciseWorkoutInterval(start: startDate,
                                                  end: endDate)
        intervals.append(interval)
    }
    
    //FOR WORKOUT WHICH IS NOT COMPOSED OF INTERVALS
//    var completeWorkout: PrancerciseWorkout? {
//        get {
//            guard state == .finished,
//                let startDate = startDate,
//                let endDate = endDate else {
//                    return nil
//            }
//
//            return PrancerciseWorkout(start: startDate,
//                                      end: endDate)
//
//        }
//    }
    
    var completeWorkout: PrancerciseWorkout? {
        guard state == .finished, intervals.count > 0 else {
            return nil
        }
        
        return PrancerciseWorkout(with: intervals)
    }
}
