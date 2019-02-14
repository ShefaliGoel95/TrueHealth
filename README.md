# TrueHealth
HealthKit provides a central repository for health and fitness data on iPhone and Apple Watch. With the user’s permission, apps communicate with the HealthKit store to access and share this data.


PART I : How to request permission to access HealthKit data, as well as read and write data to HealthKit’s central repository



(1) HOW TO REQUEST PERMISSION AND ACCESS HEALTHKIT DATA

(A) SETUP:

• Assigning a Team

HealthKit is a special framework. Your app can’t use it unless you have an active developer account. Once you have a developer account, you can assign your team.

• Entitlements

HealthKit also has its own set of entitlements, and you will need to enable them in order to build apps that use the framework.
Open the Capabilities tab in the target editor, and turn on the HealthKit switch


(B) PERMISSIONS:

⁃HealthKit deals with sensitive and private data. 
⁃has a robust privacy system. 
⁃only has access to the kinds of data your users agree to share with it.

Updating the Share Usage Descriptions
First, you need to describe why you are asking for health metrics from your users.

Open Info.plist and  add the following keys:

•Privacy – Health Share Usage Description : corresponds to data to be read from HealthKit.
•Privacy – Health Update Usage Description :  corresponds to data that gets written to HealthKit.

⁃Both keys store text that display when the HeathKit authorization screen appears. 
⁃You can put anything you want in there. For example, “We will use your health information to better track Prancercise workouts.”
⁃If those keys aren’t set, your app will crash when attempting to authorize HealthKit.

(C) AUTHORIZING HEALTHKIT:

To authorize HealthKit, the authorizeHealthKit(completion:) method will need to do these four things:

▪Check to see if Healthkit is available on this device. If it isn’t, complete with failure and an error.
▪Prepare the types of health data Prancercise Tracker will read and write to HealthKit.
▪Organize those data into a list of types to be read and types to be written.
▪Request Authorization. If it’s successful, complete with success.


1. Checking HealthKit availability

	•HKHealthStore :  

		It represents the central repository that stores a user’s health-related data. 

	•isHealthDataAvailable() :

	method helps you figure out if the user’s current device supports HeathKit data, if HealthKit isn’t available on the device, the method completes with the notAvailableOnDevice error. 

2. Preparing data types 

	•HKObjectType : 
	
	⁃	HealthKit works with a type called HKObjectType. 
	⁃	Every type that goes into and out HealthKit’s central repository is some kind of HKObjectType. 
	⁃	HKSampleType and HKWorkoutType Both inherit from HKObjectType

	•HKObjectType.characteristicType(forIdentifier:) or HKObjectType.quantityType(forIdentifier:) : 
	
	⁃	Used to create an HKObjectType for a given biological characteristic or quantity
	⁃	characteristic types and the quantity types are both enums defined by the framework

If a single characteristic or sample type is not available, the method will complete with an error because your app should always know exactly which HealthKit types it can work with, if any at all.

3. Preparing a list of data types to read and write:

	•	HKSampleType:
	
	⁃	HealthKit expects a set of HKSampleType objects that represent the kinds of data your user can write
	⁃	 it also expects a set of HKObjectType objects for your app to read

	•	HKObjectType.workoutType():
	
	⁃	a special kind of HKObjectType
	⁃	represents any kind of workout

4. Request Authorization :

	⁃	request authorization from HealthKit and then call your completion handler. 
	⁃	use the success and error variables passed in from HKHealthStore’s requestAuthorization(toShare: read: completion:) method.
	⁃	On authorization screen pop up, turn on all the switches, scrolling the screen to see all of them, and click Allow.
	⁃	Now the app has access to HealthKit’s central repository and we can start tracking things.

￼



(2) HOW TO READ FROM HEALTHKIT


LIFECYCLE :

￼



CHARACTERISTICS AND SAMPLES:

	•	Biological characteristics tend to be the kinds of things that don’t change, like your blood type. 
	•	Samples represent things that often do change, like your weight.

	⁃	The sample app doesn’t write biological characteristics. 
	⁃	It reads them from HealthKit. 
	⁃	That means those characteristics need to be stored in HeathKit’s central repository first.

(A) READ BIOLOGICAL CHARACTERISTICS:

SAVE BIOLOGICAL CHARACTERISTICS IN HEALTHKIT
	1.	Open the Health App on your device or in the simulator. 
	2.	Select the Health Data tab. 
	3.	Then tap on the profile icon in the top right hand corner to view your health profile. 
	4.	Hit Edit, and enter information for Date of Birth, Sex, Blood Type

READ THOSE CHARACTERISTICS INTO YOUR APPLICATION
	1.	Create an instance of HKHealthStore
	2.	Access different biological characteristics using healthKitStore.dateOfBirthComponents() , healthKitStore.biologicalSex(), healthKitStore.bloodType() and so on. These method can throw an error whenever the date of birth, biological sex, or blood type haven’t been saved in HealthKit’s central repository. If you have entered this information into your Health app, no error should be thrown.
	3.	You may use Calendar to calculate age using current date and dat of birth 
	4.	Unwrap the wrappers to get the underlying enum values. For example :
             let unwrappedBiologicalSex = biologicalSex.biologicalSex
             let unwrappedBloodType = bloodType.bloodType
       from a wrapper class (HKBiologicalSexObject and HKBloodTypeObject).

UPDATING THE USER INTERFACE
	1.	load the biological characteristics into the user interface.
	2.	sets those fields on a local instance of the UserHealthProfile model
	3.	it updates the user interface with the new fields on UserHealthProfile

In the sample app,  
Go into the Profile & BMI screen. 
Tap on the Read HealthKit Data button.
If you entered your information into the Health app earlier, it should appear in the labels on this screen. If you didn’t, you will get an error message.


(B) QUERY SAMPLES:

Samples use HKQuery, more specifically HKSampleQuery.

SAVE SAMPLES IN HEALTHKIT

	1.	Open the Health App on your device or in the simulator. 
	2.	Select the Health Data tab. 
	3.	Then tap on the Body Measurements in the table at the bottom.
	4.	Select the sample you want to save . For example Height.
	5.	Tap the + icon on top and record the value and press Add

QUERY SAMPLES FROM HEALTHKIT

	1.	Specify the type of sample you want to query (weight, height, etc.) using HKSampleType enum
	2.	Specify some additional parameters to help filter and sort the data. You can use HKQuery.predicateForSamples(withStart: , end: , options: ) or any other predicate method to filter and NSSortDescriptor(key: , ascending:)  for sorting.
	3.	Setup you query using  HKSampleQuery(sampleType: , predicate: , limit: , sortDescriptors: , resultsHandler: )
	4.	Once your query is setup, you simply call HKHealthStore’s executeQuery() method to fetch the results.

In the sample app , there is a single generic function that loads the most recent samples of any type. That way, you can use it for both weight and height.
This method takes in a sample type (height, weight, bmi, etc.). Then it builds a query to get the most recent sample for that type. If you pass in the sample type for height, you will get back your latest height entry.


IMPORTANT :  Querying samples from HealthKit is an asynchronous process. That is why the code in the completion handler occurs inside of a Dispatch block. You want the completion handler to happen on the main thread, so the user interface can respond to it. If you don’t do this, the app will crash.


DISPLAYING SAMPLES ON USER INTERFACE

	1.	create the type of sample you want to retrieve using HKSampleType.quantityType(forIdentifier: )
	2.	ask HealthKit for it
	3.	do some unit conversions
	4.	save to your model, and update the user interface.

In the sample application , 

Navigate to Profile & BMI. 
Then tap the Read HealthKit Data button.
Body Mass Index isn’t actually stored on the UserHealthProfile model. It’s a computed property that does the calculation


(3) HOW TO SAVE SAMPLES TO HEALTHKIT

	1.	First check if there is a quantity type for the sample to be saved (eg: body mass index) using HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) . If there is, it gets used to create a quantity and quantity sample. If not, the app intentionally crashes.
	2.	Use the Count HKUnit to create a body mass quantity. The count() method on HKUnit is for a special case when there isn’t a clear unit for the type of sample you are storing. At some point in the future, there may be a unit assigned to body mass index, but for now this more generic unit works just fine.
	3.	HKHealthStore saves the sample and lets you know if the process was successful

In the sample app, 
	1.	Go into the Profile & BMI screen. 
	2.	Load your data from HeathKit, then tap the Save BMI button.


To check in Health Application, 
	1.	Open the Health app
	2.	tap the Health Data tab
	3.	Tap on Body Measurements in the table view, and then tap on Body Mass Index.
	4.	you should see a data point like this one
		
￼



PART 2: WORKOUTS

	•	In your day-to-day life, 
	
	⁃	 It’s some period of time in which you increase physical exertion doing some sort of activity.
	⁃	Most workouts have one more of the following attributes:
	1.	Activity type (running, cycling, Prancercising, etc.)
	2.	Distance
	3.	Start and end time
	4.	Duration
	5.	Energy burned

	•	HealthKit 
	
	⁃	A workout is a container for these types of information, taken as a collection of samples. 
	⁃	A given workout might contain heart rate samples, distance samples and an activity type to categorize them.



(1) HOW TO SAVE YOUR WORKOUT TO HEALTHKIT?

	1.	Create a health store and workout configuration to store data into HealthKit using HKHealthStore() and  HKWorkoutConfiguration() respectively.
	2.	Use the HKWorkoutBuilder(healthStore:, configuration:, device: ) of HKWorkoutBuilder class (new to iOS 12) to incrementally construct a workout.
	3.	Begin collecting workout data using beginCollection(withStart: )
	4.	Creating a quantity to store the total calories burned for example , in this sample. After that, you can create a new sample.  HKCumulativeQuantitySeriesSample is a new sample type that stores the total data for a workout rather than individual values. You can use this, for example, to collect the total distance you ran in a basketball game by adding up all the individual samples.
	5.	Add the sample to the workout builder using  add(samples: , completion: )
	6.	Finish the collection of workout data and set the end date for the workout endCollection(withEnd: , completion: )
	7.	Create the workout with the samples added using builder.finishWorkout(completion: )

NOTE:  you can tell HealthKit (when creating the HKWorkoutBuilder) what device the workout was recorded on. This can be useful when querying data later.



(2) QUERYING WORKOUTS 
How to load workouts from HealthKit?

	1.	Get all workouts with the "Other" activity type.
	2.	Get all workouts that only came from this app.
	3.	Combine the predicates into a single predicate. The predicates determine what types of HeathKit data you’re looking for.
	4.	Sort the returned samples . 
	5.	Initiate the query.

FUNCTIONS :

	•	HKQuery.predicateForWorkouts(with:) 

	⁃	gives you a predicate for workouts with a certain activity type. For all activity types check enum HKWorkoutActivityType.
	⁃	 In this sample app, you’re loading any type of workout in which the activity type is other (all Prancercise workouts use the other activity type).

	•	predicateForObjects(from: )

	⁃	gives you a predicate for workouts from a certain HKSource.
	⁃	HKSource denotes the app that provided the workout data to HealthKit. Can be specified by:
              name :  The name of the source represented by the receiver.  If the source is an app, then the name is the
                    localized name of the app.
              bundleIdentifier : The bundle identifier of the source represented by the receiver.
              defaultSource : Returns the HKSource representing the calling application.

	⁃	Whenever you call HKSource.default(), you’re saying “this app.” sourcePredicate gets all workouts where the source is this app.

	•	NSCompoundPredicate.

	⁃	provides a way to bring one or more filters together.
	⁃	In the sample app , the final result is a query that gets you all workouts with other as the activity type and Prancercise Tracker as the source app.

	•	NSSortDescriptor(key: , ascending:)

	⁃	the sort descriptor tells HeathKit how to sort the samples it returns
     
	•	HKSampleQuery(sampleType: , predicate: , limit:, sortDescriptors:, resultsHandler:)

	⁃	Use the workoutType() as the HKSampleType
	⁃	In the completion handler, you unwrap the samples as an array of HKWorkout objects. That’s because HKSampleQuery returns an array of HKSample by default, and you need to cast them to HKWorkout to get all the useful properties like start time, end time, duration and energy burned.



LOADING WORKOUTS INTO THE USER INTERFACE

How to update user interface after loading required workouts from HealthKit?

	1.	load the workouts from HealthKit using loadPrancerciseWorkouts(completion:) 
	2.	Reload the tableview and populate the cells using properties of workout such as start date , end date  , totalEnergyBurned, etc.

In the sample app , 
	1.	Go to Prancercise Workouts
	2.	Tap the + button, track a short Prancercise workout
	3.	tap Done and take a look at the table view.


WORKOUTS COMPOSED OF INTERVALS

Adding Samples to Workouts
	⁃	With samples, you can record many exercise intervals under the same workout. 
	⁃	It’s a way to give HealthKit a more detailed view of what you did during your workout routine.
	⁃	You can add all kinds of samples to a workout. If you want, you can add distance, calories burned, heart rate and more.
	⁃	The sample app will focus on calorie burn samples.

Making Model Updates
	⁃	A single Workout becomes a wrapper or container for the workout intervals that store the starts and stops you took during your routine.
	⁃	a full Workout session is composed of an array of PrancerciseWorkoutInterval values. The workout starts when the first item in the array starts, and it ends when the last item in the array ends.

Workout Sessions
	1.	Create an array of  WorkoutInterval model class values:
	2.	Every time you stop the workout, a new workoutInterval with the current start and stop dates gets added to the list.  The start and end dates get reset every time a Prancercise session begins and ends.
	3.	Clear out the array whenever the workout session needs to get cleared using removeAll().

In the sample app , once the user taps Done to save the workout, 
A full workout entity is generated using the intervals recorded during the many sessions.

Adding Samples While Saving a Workout
Although the app records accurate Prancercise workouts to HealthKit, there aren’t any samples attached. We need a way to convert PrancerciseWorkoutIntervals into samples.
	1.	Prepares a list of samples using your Prancercise workout.
	2.	Add them to the workout builder as we’ve done before.





VIEWING WORKOUT SAMPLES IN THE HEALTH APP:


	1.	Open the Health app. 
	2.	Tap the second tab labeled Health Data, then tap on Activity. You should see a breakdown of your workouts for the day.
	3.	Tap Workouts. The next screen will give you a breakdown of your workouts for the day.
	4.	Tap Show All Data. This will take you to a screen that displays all your workouts for the day, along with their source app.
	5.	Tap on a workout to view its details. 
	6.	Scroll down to the Workout Samples section, and then tap on the cell displaying the total active energy.
	7.	At this point, you should see a list of active energy samples associated with the Prancercise workout you just tracked.
	8.	Tap on a sample, and you can see when your short Prancercise session started and finished.


￼

￼



Contents of Files :


	•	HealthKitSetupAssistant.swift
	⁃	authorize HealthKit

	•	ProfileDataStore.swift
	⁃	Loading biological charcteristics and samples
	⁃	save samples to HealthKit

	•	ProfileViewController.swift
	⁃	Load and display biological characteristics and samples from healthKit

	•	WorkoutDataStore :
	⁃	save workouts to HealthKit 
	⁃	Load workouts from HealthKit 
	⁃	creating a sample for each Interval associated with a Workout.

	•	WorkoutsTableViewController
	⁃	load the workouts from HealthKit 
	⁃	Update the user interface to show loaded workouts

	•	Workout.swift
	⁃	Contains the models the app uses to store information related to a workout and a particular workout interval

	•	WorkoutSession.swift
	⁃	store data related to the current workout being tracked.


