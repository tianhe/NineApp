//
//  HistoryViewController.swift
//  Nine
//
//  Created by Tian He on 3/13/16.
//  Copyright © 2016 Tian He. All rights reserved.
//

import UIKit
import CoreData
import Charts

class HistoryViewController : UIViewController {
    var moods = [FWMood]()
    let days = [String]()
    let energyChart = LineChartView()
    var lastDay = NSDate()
    let numberOfDays = 7
    let hoursGranularity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.secondaryLightColor
        energyChart.frame = CGRectMake(0, 100, screenBoundsFixedToPortraitOrientation().width, 200.0)
        self.view.addSubview(energyChart)
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let moodsFetch = NSFetchRequest(entityName: "Mood")
        
        
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        moodsFetch.sortDescriptors = [sortDescriptor];
        
        do {
            self.moods = try managedContext.executeFetchRequest(moodsFetch) as! [FWMood]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }

        let dateAndHourStrings = getDateAndHourStrings(getFirstDay(), days: numberOfDays, samplesPerDay: 24/hoursGranularity)
        let values = getEnergyValuesForDayRanges(getFirstDay(), days: numberOfDays)
        setChart(energyChart, dateAndHourStrings: dateAndHourStrings, values: values)
        energyChart.gridBackgroundColor = UIColor.darkGrayColor()
        energyChart.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDateAndHourStrings(startDay: NSDate, days: Int, samplesPerDay: Int) -> [String] {
        var dateAndHourStringArray: [String] = []
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd HH:00"
        
        for i in 0...days*samplesPerDay {
            let dayAndHour = startDay.dateByAddingTimeInterval(NSTimeInterval(60*60*24*(i/samplesPerDay)+i%samplesPerDay*60*60))
            let dateAndHourString = formatter.stringFromDate(dayAndHour)
            dateAndHourStringArray.append(dateAndHourString)
        }
        return dateAndHourStringArray
    }
    
    func getEnergyValuesForDayRanges(startDate: NSDate, days: Int) -> [Double] {
        let numberOfDataPoints = numberOfDays*(24/hoursGranularity)+1
        var valueArray = [Double](count: numberOfDataPoints, repeatedValue: 0.0)
        
        let maxTimeDifferenceInHours = Double(numberOfDays*24/hoursGranularity)
        
        for mood in self.moods {
            if mood.created_at != nil {
                let timeDifferenceInHours = mood.created_at!.timeIntervalSinceDate(startDate)/(60*60)
                if(timeDifferenceInHours > 0 && timeDifferenceInHours < maxTimeDifferenceInHours) {
                    let xIndex = Int(timeDifferenceInHours) / hoursGranularity
                    valueArray[xIndex] = Double(mood.energy!)
                }
            }
        }
        return valueArray
    }
    
    func setChart(lineChart: LineChartView, dateAndHourStrings: [String], values: [Double]) {
        lineChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<dateAndHourStrings.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Energy")
        chartDataSet.setColor(Constants.primaryColor)
        chartDataSet.setCircleColor(UIColor.redColor())
        chartDataSet.lineWidth = 2.0
        chartDataSet.circleRadius = 6.0
        chartDataSet.fillAlpha = 65/255.0
        chartDataSet.fillColor = UIColor.redColor()
        chartDataSet.drawCircleHoleEnabled = true
        
        let chartData = LineChartData(xVals: dateAndHourStrings, dataSet: chartDataSet)
        lineChart.data = chartData
    }
    
    func getFirstDay() -> NSDate {
        return lastDay.dateByAddingTimeInterval(NSTimeInterval(-60*60*24*numberOfDays))
    }
    
    
}
