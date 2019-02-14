//
//  WorkoutDataStore.swift
//  Prancercise Tracker
//
//  Created by Shefali Goel on 12/02/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//


//MARK::- MODULES
import HealthKit

class WorkoutDataStore {
    
    
    //MARK::- SAVE WORKOUTS FOR WORKOUR WITHOUT INTERVALS
//    @available(iOS 12.0, *)
//    class func save(prancerciseWorkout: PrancerciseWorkout,
//                    completion: @escaping ((Bool, Error?) -> Swift.Void)) {
//
//        let healthStore = HKHealthStore()
//        let workoutConfiguration = HKWorkoutConfiguration()
//        workoutConfiguration.activityType = .other
//
//        let builder = HKWorkoutBuilder(healthStore: healthStore,
//                                       configuration: workoutConfiguration,
//                                       device: .local())
//        builder.beginCollection(withStart: prancerciseWorkout.start) { (success, error) in
//            guard success else {
//                completion(false, error)
//                return
//            }
//            guard let quantityType = HKQuantityType.quantityType(
//                forIdentifier: .activeEnergyBurned) else {
//                    completion(false, nil)
//                    return
//            }
//
//            let unit = HKUnit.kilocalorie()
//            let totalEnergyBurned = prancerciseWorkout.totalEnergyBurned
//            let quantity = HKQuantity(unit: unit,
//                                      doubleValue: totalEnergyBurned)
//            let sample = HKCumulativeQuantitySeriesSample(type: quantityType,
//                                                          quantity: quantity,
//                                                          start: prancerciseWorkout.start,
//                                                          end: prancerciseWorkout.end)
//
//
//            //1. Add the sample to the workout builder
//            builder.add([sample]) { (success, error) in
//                guard success else {
//                    completion(false, error)
//                    return
//                }
//
//                //2. Finish collection workout data and set the workout end date
//                builder.endCollection(withEnd: prancerciseWorkout.end) { (success, error) in
//                    guard success else {
//                        completion(false, error)
//                        return
//                    }
//
//                    //3. Create the workout with the samples added
//                    builder.finishWorkout { (_, error) in
//                        let success = error == nil
//                        completion(success, error)
//                    }
//                }
//            }
//
//        }
//    }
    
    
    //MARK::- SAVE WORKOUTS FOR WORKOUR WITH INTERVALS
    @available(iOS 12.0, *)
    class func save(prancerciseWorkout: PrancerciseWorkout,
                    completion: @escaping ((Bool, Error?) -> Swift.Void)) {
        
        let healthStore = HKHealthStore()
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        
        let builder = HKWorkoutBuilder(healthStore: healthStore,
                                       configuration: workoutConfiguration,
                                       device: .local())
        builder.beginCollection(withStart: prancerciseWorkout.start) { (success, error) in
            guard success else {
                completion(false, error)
                return
            }
            let samples = self.samples(for: prancerciseWorkout)
            
            
           
            
            builder.add(samples) { (success, error) in
                guard success else {
                    completion(false, error)
                    return
                }
                
                builder.endCollection(withEnd: prancerciseWorkout.end) { (success, error) in
                    guard success else {
                        completion(false, error)
                        return
                    }
                    
                   
                    builder.finishWorkout { (workout, error) in
                        let success = error == nil
                        completion(success, error)
                    }
                }
            }
        }
    }
    
    
    
    
    @available(iOS 12.0, *)
    private class func samples(for workout: PrancerciseWorkout) -> [HKSample] {
        //1. Verify that the energy quantity type is still available to HealthKit.
        guard let energyQuantityType = HKSampleType.quantityType(
            forIdentifier: .activeEnergyBurned) else {
                fatalError("*** Energy Burned Type Not Available ***")
        }
        
        //2. Create a sample for each PrancerciseWorkoutInterval
        let samples: [HKSample] = workout.intervals.map { interval in
            let calorieQuantity = HKQuantity(unit: .kilocalorie(),
                                             doubleValue: interval.totalEnergyBurned)
            
            return HKCumulativeQuantitySeriesSample(type: energyQuantityType,
                                                    quantity: calorieQuantity,
                                                    start: interval.start,
                                                    end: interval.end)
        }
        
        return samples
    }
    
    
    
    
    
    
    
    
    
    //MARK::- LOAD WORKOUTS FROM HEALTHKIT
    class func loadPrancerciseWorkouts(completion:
        @escaping ([HKWorkout]?, Error?) -> Void) {
        
        //1. Get all workouts with the "Other" activity type.
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .other)
        
        //2. Get all workouts that only came from this app.
        let sourcePredicate = HKQuery.predicateForObjects(from: .default())
        
        //3. Combine the predicates into a single predicate.
        //predicates determine what types of HeathKit data you’re looking for
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:
            [workoutPredicate, sourcePredicate])
        
        //sort descriptor tells HeathKit how to sort the samples it returns
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: compound, limit: 0, sortDescriptors: [sortDescriptor]){ (query, samples, error) in
            DispatchQueue.main.async {
                guard
                    
                    //unwrap the samples as an array of HKWorkout objects because HKSampleQuery returns an array of HKSample by default, and you need to cast them to HKWorkout to get all the useful properties like start time, end time, duration and energy burned.
                    let samples = samples as? [HKWorkout],
                    error == nil
                    else {
                        completion(nil, error)
                        return
                }
                
                completion(samples, nil)
            }
        }
        HKHealthStore().execute(query)
    }
}
