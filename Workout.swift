//
//  Workout.swift
//  Prancercise Tracker
//
//  Created by Shefali Goel on 12/02/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//


//MARK::- MODULES
import Foundation


//MARK::- ENTIRE WORKOUT ( used when a workout session is not composed of intervals)
//struct PrancerciseWorkout {
//
//
//    //MARK::- PROPERTIES
//    var start: Date
//    var end: Date
//
//    init(start: Date, end: Date) {
//        self.start = start
//        self.end = end
//    }
//
//    var duration: TimeInterval {
//        return end.timeIntervalSince(start)
//    }
//
//    var totalEnergyBurned: Double {
//
//        let prancerciseCaloriesPerHour: Double = 450
//        let hours: Double = duration/3600
//        let totalCalories = prancerciseCaloriesPerHour*hours
//        return totalCalories
//    }
//}


//MARK::- A PIECE OF WORKOUT ( used when a workout session is composed of intervals)
struct PrancerciseWorkoutInterval {
    var start: Date
    var end: Date
    
    var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
    
    var totalEnergyBurned: Double {
        let prancerciseCaloriesPerHour: Double = 450
        let hours: Double = duration / 3600
        let totalCalories = prancerciseCaloriesPerHour * hours
        return totalCalories
    }
}

struct PrancerciseWorkout {
    var start: Date
    var end: Date
    var intervals: [PrancerciseWorkoutInterval] //a full PrancerciseWorkout is composed of an array of PrancerciseWorkoutInterval values. The workout starts when the first item in the array starts, and it ends when the last item in the array ends.
    
    init(with intervals: [PrancerciseWorkoutInterval]) {
        self.start = intervals.first!.start
        self.end = intervals.last!.end
        self.intervals = intervals
    }
    
    var totalEnergyBurned: Double {
        return intervals.reduce(0) { (result, interval) in
            result + interval.totalEnergyBurned
        }
    }
    
    var duration: TimeInterval {
        return intervals.reduce(0) { (result, interval) in
            result + interval.duration
        }
    }
}
