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

class FWHistoryViewController : UIViewController {
    var moods = [FWMood]()
    let days = [String]()
    let energyChart = LineChartView()
    let moodChart = LineChartView()
    let hoursGranularity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.secondaryLightColor
        energyChart.frame = CGRectMake(0, 50, screenBoundsFixedToPortraitOrientation().width, 200.0)
        self.view.addSubview(energyChart)

        moodChart.frame = CGRectMake(0, 250, screenBoundsFixedToPortraitOrientation().width, 200.0)
        self.view.addSubview(moodChart)
        
        let dayRangeSelector = UISegmentedControl(items: ["1 day", "3 days", "7 days"])
        dayRangeSelector.frame = CGRectMake(50, 475, screenBoundsFixedToPortraitOrientation().width-100, 40)
        dayRangeSelector.addTarget(self, action: "didSelectDayRange:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(dayRangeSelector)
    }
    
    func didSelectDayRange(sender: UISegmentedControl!) {
        let days = [1, 3, 7]
        refreshChartsForNumberOfDays(days[sender.selectedSegmentIndex])
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
        
        refreshChartsForNumberOfDays(7)
    }
    
    func refreshChartsForNumberOfDays(numberOfDays: Int) {
        let firstDay = getFirstDay(NSDate(), days: numberOfDays)
        
        let dateAndHourStrings = getDateAndHourStrings(firstDay, days: numberOfDays, samplesPerDay: 24/hoursGranularity)
        let energyValues = getEnergyValuesForDayRanges(firstDay, days: numberOfDays)
        setChart(energyChart, dateAndHourStrings: dateAndHourStrings, values: energyValues, label: "Energy")
        energyChart.gridBackgroundColor = UIColor.darkGrayColor()
        energyChart.sizeToFit()
        
        let moodValues = getMoodValuesForDayRanges(firstDay, days: numberOfDays)
        setChart(moodChart, dateAndHourStrings: dateAndHourStrings, values: moodValues, label: "Mood")
        moodChart.gridBackgroundColor = UIColor.darkGrayColor()
        moodChart.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDateAndHourStrings(startDay: NSDate, days: Int, samplesPerDay: Int) -> [String] {
        var dateAndHourStringArray: [String] = []
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d ha"
        
        for i in 0...days*samplesPerDay {
            let dayAndHour = startDay.dateByAddingTimeInterval(NSTimeInterval(60*60*24*(i/samplesPerDay)+i%samplesPerDay*60*60))
            let dateAndHourString = formatter.stringFromDate(dayAndHour)
            dateAndHourStringArray.append(dateAndHourString)
        }
        return dateAndHourStringArray
    }
    
    func getEnergyValuesForDayRanges(startDate: NSDate, days: Int) -> [Double] {
        let numberOfDataPoints = days*(24/hoursGranularity)+1
        var valueArray = [Double](count: numberOfDataPoints, repeatedValue: 0.0)
        
        let maxTimeDifferenceInHours = Double(days*24/hoursGranularity)
        
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

    func getMoodValuesForDayRanges(startDate: NSDate, days: Int) -> [Double] {
        let numberOfDataPoints = days*(24/hoursGranularity)+1
        var valueArray = [Double](count: numberOfDataPoints, repeatedValue: 0.0)
        
        let maxTimeDifferenceInHours = Double(days*24/hoursGranularity)
        
        for mood in self.moods {
            if mood.created_at != nil {
                let timeDifferenceInHours = mood.created_at!.timeIntervalSinceDate(startDate)/(60*60)
                if(timeDifferenceInHours > 0 && timeDifferenceInHours < maxTimeDifferenceInHours) {
                    let xIndex = Int(timeDifferenceInHours) / hoursGranularity
                    valueArray[xIndex] = Double(mood.mood!)
                }
            }
        }
        return valueArray
    }

    func setChart(lineChart: LineChartView, dateAndHourStrings: [String], values: [Double], label: String) {
        lineChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<dateAndHourStrings.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: label)
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
    
    func getFirstDay(lastDay: NSDate, days: Int) -> NSDate {
        return lastDay.dateByAddingTimeInterval(NSTimeInterval(-60*60*24*days))
    }
    
    
}
