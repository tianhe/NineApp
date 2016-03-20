//
//  TrackViewController.swift
//  Nine
//
//  Created by Tian He on 3/12/16.
//  Copyright © 2016 Tian He. All rights reserved.
//

import UIKit
import CoreData

class FWGridTrackViewController: UIViewController {
    //weak var tableView: UITableView!
    var moods = [NSManagedObject]()
    var selectedEnergy = 0
    var selectedMood = 0
    var buttons = [UIButton]()
    var lastTappedButton: UIButton?
    var doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()

        // Do any additional setup after loading the view, typically from a nib.
        let width = screenBoundsFixedToPortraitOrientation().width
        let height = screenBoundsFixedToPortraitOrientation().height
        let margins = CGFloat(75.0)
        let buttonSize = (width - margins)/3
        
        for index in 0...8 {
            let row = CGFloat(index / 3)
            let column = CGFloat(index % 3)
            
            let button   = UIButton(frame: CGRectMake(margins/2+buttonSize*(column), margins/2+buttonSize*(3-row), buttonSize, buttonSize))
            
            button.backgroundColor = UIColor.whiteColor()
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.grayColor().CGColor
            button.tag = index
            button.setTitle(String(index), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: "moodSelected:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
            buttons.append(button)
        }
        
        let xLabel = UILabel(frame: CGRectMake(margins/2+buttonSize*2-70, margins/2+buttonSize*4, 100, 40))
        xLabel.text = "Energy"
        xLabel.textColor = Constants.primaryLightColor
        self.view.addSubview(xLabel)

        let yLabel = UILabel(frame: CGRectMake(0, margins/2+buttonSize*2, 50, 70))
        yLabel.text = "Mood"
        yLabel.textColor = Constants.primaryLightColor
        yLabel.transform = CGAffineTransformMakeRotation(CGFloat((270.0 * M_PI)/180.0))
        self.view.addSubview(yLabel)

        doneButton   = UIButton(frame: CGRectMake(margins/2, height - margins - 60, buttonSize*3, 60))
        doneButton.setTitle("DONE", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "doneSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.tag = 9
        doneButton.enabled = false
        doneButton.backgroundColor = Constants.primaryColor
        self.view.addSubview(doneButton)
    }
        
    //Selectors
    
    func moodSelected(sender: UIButton!) {
        let score: NSNumber = sender.tag
        
        selectedMood = Int(score)%3
        selectedEnergy = Int(score)/3
        
        if self.lastTappedButton != nil {
            lastTappedButton!.backgroundColor = UIColor.whiteColor()
        }
        self.lastTappedButton = sender
        
        sender.backgroundColor = Constants.colorScheme[sender.tag]
        doneButton.enabled = true
    }
    
    func doneSelected(sender: UIButton!) {
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
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        self.lastTappedButton!.backgroundColor = Constants.primaryLightColor
        doneButton.enabled = false
    }
}
