//
//  TrackViewController.swift
//  Nine
//
//  Created by Tian He on 3/12/16.
//  Copyright © 2016 Tian He. All rights reserved.
//

import UIKit
import CoreData

class FWSliderTrackViewController: UIViewController {
    //weak var tableView: UITableView!
    var moods = [NSManagedObject]()
    var selectedEnergy = 0
    var selectedMood = 0
    var energySlider = UISlider()
    var moodSlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        
        // Do any additional setup after loading the view, typically from a nib.
        let width = screenBoundsFixedToPortraitOrientation().width
        let height = screenBoundsFixedToPortraitOrientation().height
        let margins = CGFloat(75.0)
        let sliderWidth = width - margins
        
        //energy
        let energyInput = inputUnit(CGRectMake(margins/2, 250, sliderWidth, 150), labelText: "Energy", action: "energySelected:")
        self.view.addSubview(energyInput)

        
        //mood
        let moodInput = inputUnit(CGRectMake(margins/2, 400, sliderWidth, 150), labelText: "Mood", action: "moodSelected:")
        self.view.addSubview(moodInput)
        
        
        //save
        let saveButton   = UIButton(frame: CGRectMake(margins/2, height - margins - 60, sliderWidth, 60))
        saveButton.setTitle("SAVE", forState: UIControlState.Normal)
        saveButton.addTarget(self, action: "saveSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.backgroundColor = Constants.primaryColor
        self.view.addSubview(saveButton)
    }
    
    func inputUnit(rect: CGRect, labelText: String, action: Selector) -> FWSliderInputView {
        let inputUnit = FWSliderInputView(frame: rect)

        let moodLabel = UILabel(frame: CGRectMake(0, 0, 100, 40))
        moodLabel.text = labelText
        moodLabel.textColor = Constants.primaryLightColor
        inputUnit.addSubview(moodLabel)

        let slider = UISlider(frame: CGRectMake(0, 30, rect.width, 40))
        slider.maximumTrackTintColor = Constants.primaryColor
        slider.minimumTrackTintColor = Constants.tertiaryColor
        slider.maximumValue = Constants.NormalizedScore
        slider.minimumValue = -1*Constants.NormalizedScore
        slider.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        slider.trackRectForBounds(CGRectMake(0, 0, rect.width, 40))
        inputUnit.addSubview(slider)
        
        return inputUnit
    }
    
    //Selectors
    func moodSelected(sender: UISlider!) {
        let score :Float = sender.value
        selectedMood = Int(score*Float(100.0)/Constants.NormalizedScore)
    }

    func energySelected(sender: UISlider!) {
        let score :Float = sender.value
        selectedEnergy = Int(score*Float(100.0)/Constants.NormalizedScore)
    }
    
    //Save Data
    func saveSelected(sender: UIButton!) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Mood", inManagedObjectContext: managedContext)
        let mood = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        mood.setValue(selectedEnergy, forKey: "energy")
        mood.setValue(selectedMood, forKey: "mood")
        mood.setValue(NSDate(), forKey: "created_at")
        
        do {
            try managedContext.save()
            moods.append(mood)
            
            let alert = UIAlertController(title: "Success", message: "Saved", preferredStyle: UIAlertControllerStyle.Alert)
            self .presentViewController(alert, animated: true, completion:nil)
            
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "dismissAlert", userInfo: nil, repeats: false)
            
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func dismissAlert() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
