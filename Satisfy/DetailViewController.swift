//
//  DetailViewController.swift
//  Satisfy
//
//  Created by Pierre on 17/04/2018.
//  Copyright © 2018 boudonpierre. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var pod = [Pod]()
    
    var greenButton = 0
    var yellowButton = 0
    var redButton = 0
    var yValues = [Int: Double]()
    
    var pChart = PieChartView(frame: CGRect(x: 25, y: 125, width: 375, height: 375))
    var bChart = BarChartView(frame: CGRect(x: 50 + 275, y: 125 + 290, width: 375, height: 375))

    func configureView() {
        // Update the user interface for the detail item.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        //self.view.backgroundColor = UIColor.white
        
        
        
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.isHidden = true
                self.title = detail.satisfactions.first?.namePod
            }
            
            for sat in detail.satisfactions {
                if sat.idButton == 0 {
                    self.greenButton += 1
                }
                else if sat.idButton == 1 {
                    self.yellowButton += 1
                }
                else if sat.idButton == 2 {
                    self.redButton += 1
                }
            }
            
            var ar = [Int : Double]()
            var currentItem = 0.0
            var sumItem = 0.0
            for i in 0..<detail.satisfactions.count {
                let sat = detail.satisfactions[i]
                if i == 0 {
                    if sat.idButton == 0 {
                        currentItem += 1
                    }
                    else if sat.idButton == 2 {
                        currentItem -= 0.5
                    }
                } else if i == detail.satisfactions.count - 1 {
                    let hour = Calendar.current.component(.hour, from: sat.date)
                    ar[hour] = currentItem / sumItem
                    currentItem = 0.0
                    sumItem = 0.0
                } else {
                    let prevSat = detail.satisfactions[i-1]
                    let hour1 = Calendar.current.component(.hour, from: prevSat.date)
                    let hour2 = Calendar.current.component(.hour, from: sat.date)
                    
                    if hour1 != hour2 {
                        ar[hour1] = currentItem / sumItem
                        currentItem = 0.0
                        sumItem = 0.0
                    }
                    
                    if sat.idButton == 0 {
                        currentItem += 1.0
                    }
                    else if sat.idButton == 2 {
                        currentItem -= 0.5
                    }
                }
                
                sumItem += 1
            }
            
            self.yValues = ar
        }
        
        
    }
    
    public func configureCharts() {
        self.pChart.entryLabelColor = .white
        
        let valuesGreen = PieChartDataEntry(value: Double(self.greenButton), label: "Satisfait")
        let valuesYellow = PieChartDataEntry(value: Double(self.yellowButton), label: "Neutre")
        let valuesRed = PieChartDataEntry(value: Double(self.redButton), label: "Pas Satisfait")
        let set = PieChartDataSet(values: [valuesGreen, valuesYellow, valuesRed], label: nil)
        
        let greenColor = NSUIColor(red: 71 / 255, green: 160 / 255, blue: 37 / 255, alpha: 1)
        let yellowColor = NSUIColor(red: 250 / 255, green: 166 / 255, blue: 19 / 255, alpha: 1)
        let redColor = NSUIColor(red: 247 / 255, green: 23 / 255, blue: 53 / 255, alpha: 1)

        set.colors = [greenColor, yellowColor, redColor]
        let data = PieChartData(dataSet: set)
        
        self.pChart.data = data
        
        self.pChart.drawCenterTextEnabled = false
        self.pChart.drawHoleEnabled = true
        self.pChart.holeColor = NSUIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.pChart.legend.textColor = .white
        
        self.view.addSubview(self.pChart)
        self.pChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        
        
        
        
        
        
        self.bChart.drawBarShadowEnabled = false
        self.bChart.drawValueAboveBarEnabled = false
        
        self.bChart.maxVisibleCount = 60
        
        let xAxis = self.bChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 2
        xAxis.axisRange = 100
        xAxis.labelCount = 5
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.gridColor = .white
        xAxis.axisLineColor = .white
        xAxis.labelTextColor = .white
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = self.bChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        leftAxis.gridColor = .white
        leftAxis.zeroLineColor = .white
        leftAxis.labelTextColor = .white
        leftAxis.axisLineColor = .white
        
        let rightAxis = self.bChart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        rightAxis.gridColor = .white
        rightAxis.zeroLineColor = .white
        rightAxis.labelTextColor = .white
        rightAxis.axisLineColor = .white
        
        let l = self.bChart.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        l.textColor = .white
        
        
        
        var yVals = [BarChartDataEntry]()
        for i in 14...24 {
            if let v = self.yValues[i] {
                yVals.append(BarChartDataEntry(x: Double(i), y: Double(v)))
            } else if i == 16 {
                yVals.append(BarChartDataEntry(x: Double(i), y: 0.0))
            }
        }
        
        for i in 0...14 {
            if let v = self.yValues[i] {
                yVals.append(BarChartDataEntry(x: Double(i), y: Double(v)))
            } else if i == 9 {
                yVals.append(BarChartDataEntry(x: Double(i), y: 0.0))
            }
        }
        
        bChart.legend.textColor = .white
        
        let bSet = BarChartDataSet(values: yVals, label: nil)
        bSet.colors = ChartColorTemplates.pastel()
        
        let bData = BarChartData(dataSet: bSet)
        bData.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        bData.barWidth = 1
        bChart.data = bData
        
        self.view.addSubview(self.bChart)
        self.bChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Pod? {
        didSet {
            // Update the view.
            configureView()
            configureCharts()
        }
    }
}

