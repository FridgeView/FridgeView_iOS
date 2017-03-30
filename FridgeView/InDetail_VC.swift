//
//  InDetail_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/2/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import Charts
class InDetail_VC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var passedData : SensorData? = nil
    let dateFormatter = DateFormatter()
    let shortDateFormatter = DateFormatter()

    var plots = [plotPoint]()
    var temperatureGraph: LineChartView?
    var tempGraphColor = [UIColor]()
    var humidityGraph: LineChartView?
    var humGraphColor = [UIColor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/YY hh:mm a"
        shortDateFormatter.dateFormat = "MM/dd"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 320
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = (passedData?.cube?.deviceName ?? "")
    }
    
    func infoForHumidty(humidity : Double) -> String {
        if humidity < 20 {
            //low
            return (passedData?.humidity?.formatHum() ?? "0%") + " humidity is ideal for things that rot such as apples, avocados, apricots, cantaloupes, honeydew, kiwi, nectarines peaches, pears, plums, strawberries, and tomatoes. Keeping the humidity low, and allowing the ethylene gas produced by these items to escape keeps these fruits and vegetables from rotting."
        } else  {
            //high
            return (passedData?.humidity?.formatHum() ?? "0%") + " percent humidity is ideal for things that will wilt such as asparagus, broccoli, cauliflower, cucumbers, citrus eggplant, green beans, arugula, spinach, and basil. By keeping a higher humidity, the moisture keeps these fruits and vegetables crisper and fresher longer."
        }
    }
    
    func levelForTemp(temp : Double) -> Int {
        //1 too cold
        //2 ideal
        //3 too hot
        //freezer
        if case -26 ... -17.5 = temp {
            //ideal
            return 2
        } else if case -35 ... -26 = temp {
            //slightly too cold
            return 1
        } else if case -17.5 ... -12 = temp {
            //slightly too warm
            return 3
        }
        
        //fridge
        if case 0.5 ... 4.4 = temp {
            //ideal
            return 2
        } else if case -12 ... 0.5 = temp {
            //slightly too cold
            return 1
        } else if case 4.4 ... 10 = temp {
            //slightly too warm
            return 3
        }
        
        //pantry
        if case 15.5 ... 28 = temp {
            //ideal
            return 2
        } else if case 10 ... 15.5 = temp { 
            //slightly too cold
            return 1
        } else if case 28 ... 50 = temp {
            //slightly too warm
            return 3
        }
        return -1

    }
    
    func infoForTemperature(temp : Double) -> String {
        
        // 15 - 26 is ideal for pantry
        // 1.5 - 4.2 is ideal for fridge
        // -28 - -17.8 is ideal for freezer
        //🙂😐☹️✅❗️

        
        //freezer
        if case -26 ... -17.5 = temp {
            //ideal
            return "✅ This temperature is in the ideal range for a freezer"
        } else if case -35 ... -26 = temp {
            //slightly too cold
            return "🔵 This temperature is too cold for a freezer"
        } else if case -17.5 ... -12 = temp {
            //slightly too warm
            return "🔴 This temperature is too cold for a freezer"
        }
        
        //fridge
        if case 0.5 ... 4.4 = temp {
            //ideal
            return "✅ This temperature is in the ideal range for a refrigerator"
        } else if case -12 ... 0.5 = temp {
            //slightly too cold
            return "🔵 This temperature is too cold for a refrigerator"
        } else if case 4.4 ... 10 = temp {
            //slightly too warm
            return "🔴 This temperature is too warm for a refrigerator"
        }
        
        //pantry
        if case 15.5 ... 26.7 = temp {
            //ideal
            return  "✅ This temperature is in the ideal range for a pantry"
        } else if case 10 ... 15.5 = temp {
            //slightly too cold
            return  "🔵 This temperature is too cold for a pantry"
        } else if case 26.7 ... 50 = temp {
            //slightly too warm
            return "🔴 This temperature is too warm for a pantry"
        }
        return ""
    }

    
    func loadHumidityGraph() {
        if let humidityGraph = humidityGraph {
            var dataEntries = [ChartDataEntry]()
            for i in stride(from: plots.count - 1, to: -1, by: -1){
                let currentPlot = plots[i]
                let dataEntry = ChartDataEntry(x: currentPlot.date.timeIntervalSince1970, y: currentPlot.huimidty)
                dataEntries.append(dataEntry)
                if currentPlot.date.timeIntervalSince1970 == passedData?.createdAt?.timeIntervalSince1970 {
                    humGraphColor.append(UIColor.green)
                } else {
                    humGraphColor.append(UIColor.black)
                }
            }
            let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Hum")
            let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray
            let colorLocations : [CGFloat] = [1.0, 0.0]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
            lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
            lineChartDataSet.drawFilledEnabled = true
            lineChartDataSet.setColor(UIColor.black)
            lineChartDataSet.lineWidth = 1.3
            lineChartDataSet.circleRadius = 4
            lineChartDataSet.circleColors = humGraphColor
            lineChartDataSet.setDrawHighlightIndicators(false)
            lineChartDataSet.drawValuesEnabled = false
            
            let lineChartData = LineChartData(dataSet: lineChartDataSet as IChartDataSet)
            humidityGraph.data = lineChartData
            
            humidityGraph.doubleTapToZoomEnabled = false
            humidityGraph.pinchZoomEnabled = false
            humidityGraph.scaleXEnabled = false
            humidityGraph.scaleYEnabled = false
            humidityGraph.chartDescription = nil
            humidityGraph.legend.enabled = false
            
            humidityGraph.rightAxis.enabled = false
            humidityGraph.xAxis.avoidFirstLastClippingEnabled = true
            humidityGraph.xAxis.labelPosition = .bottom
            humidityGraph.xAxis.setLabelCount(plots.count / 2, force: true)
            humidityGraph.xAxis.drawGridLinesEnabled = false
            humidityGraph.xAxis.valueFormatter = self
            humidityGraph.leftAxis.drawGridLinesEnabled = false
            
            //cell.graphView.highlightValue(x: pointToHighlight.date.timeIntervalSince1970, y: pointToHighlight.temperature, dataSetIndex: 0)
            //humidityGraph.animate(yAxisDuration: 1.5, easingOption: ChartEasingOption.easeInElastic)
            
        }
    }

    func loadTemperatureGraph() {
        if let temperatureGraph = temperatureGraph {
            var dataEntries = [ChartDataEntry]()
            for i in stride(from: plots.count - 1, to: -1, by: -1){
                let currentPlot = plots[i]
                let dataEntry = ChartDataEntry(x: currentPlot.date.timeIntervalSince1970, y: currentPlot.temperature.convertTemp())
                dataEntries.append(dataEntry)
                if currentPlot.date.timeIntervalSince1970 == passedData?.createdAt?.timeIntervalSince1970 {
                    switch levelForTemp(temp: currentPlot.temperature ) {
                    case 1:
                        tempGraphColor.append(UIColor.blue)
                    case 2:
                        tempGraphColor.append(UIColor.green)
                    case 3:
                        tempGraphColor.append(UIColor.red)
                    default:
                        tempGraphColor.append(UIColor.black)
                    }
                } else {
                    tempGraphColor.append(UIColor.black)
                }
            }
            
            let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Temp")
            let gradientColors = [UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray
            let colorLocations : [CGFloat] = [1.0, 0.0]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
            lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
            lineChartDataSet.drawFilledEnabled = true
            lineChartDataSet.setColor(UIColor.black)
            lineChartDataSet.lineWidth = 1.3
            lineChartDataSet.circleRadius = 4
            lineChartDataSet.circleColors = tempGraphColor
            lineChartDataSet.setDrawHighlightIndicators(false)
            lineChartDataSet.drawValuesEnabled = false
            
            let lineChartData = LineChartData(dataSet: lineChartDataSet as IChartDataSet)
            temperatureGraph.data = lineChartData
            
            temperatureGraph.doubleTapToZoomEnabled = false
            temperatureGraph.pinchZoomEnabled = false
            temperatureGraph.scaleXEnabled = false
            temperatureGraph.scaleYEnabled = false
            temperatureGraph.chartDescription = nil
            temperatureGraph.legend.enabled = false
            
            temperatureGraph.rightAxis.enabled = false
            temperatureGraph.xAxis.avoidFirstLastClippingEnabled = true
            temperatureGraph.xAxis.labelPosition = .bottom
            temperatureGraph.xAxis.setLabelCount(plots.count / 2, force: true)
            temperatureGraph.xAxis.drawGridLinesEnabled = false
            temperatureGraph.xAxis.valueFormatter = self
            temperatureGraph.leftAxis.drawGridLinesEnabled = false
            
            //cell.graphView.highlightValue(x: pointToHighlight.date.timeIntervalSince1970, y: pointToHighlight.temperature, dataSetIndex: 0)
            //temperatureGraph.animate(yAxisDuration: 1.5, easingOption: ChartEasingOption.easeInElastic)

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension InDetail_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 15
//        } else if indexPath.row == 1 {
//            return 95
//        } else if indexPath.row == 2 {
//            return 30
//        } else if indexPath.row == 3 {
//            return 325
//        } else if indexPath.row == 4 {
//            return 30
//        } else {
//            return 325
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if (indexPath.row == 0 ) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "sensorDataCell", for: indexPath) as! SensorDataCell
//            cell.selectionStyle = .none
//            if let passedData = passedData {
//                cell.cellTitle.text = "\(passedData.cube?.deviceName ?? "")"
//                cell.temperature.text = passedData.temperature?.formatTemp()
//                cell.humidity.text = "\(Double(round(CGFloat(passedData.humidity ?? 0) * 10)/10))%"
//                cell.dateLabel.text = "\(dateFormatter.string(from: passedData.createdAt ?? Date()))"
//            }
//            return cell
         if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileHeaderCell
            cell.selectionStyle = .none
            if let temp = passedData?.temperature,
                let date = passedData?.createdAt {
                cell.mainLabel.text = "Temperature (\(temp.formatTemp())) - \(dateFormatter.string(from: date))"
            } else {
                cell.mainLabel.text = "Temperature"
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "graphInfoCell", for: indexPath) as! GraphCell
            cell.selectionStyle = .none
            cell.infoText.text = infoForTemperature(temp: passedData?.temperature as? Double ?? 0)
            if self.temperatureGraph == nil {
                self.temperatureGraph = cell.graphView
                self.loadTemperatureGraph()
            }
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileHeaderCell
            cell.selectionStyle = .none
            if let hum = passedData?.humidity,
                let date = passedData?.createdAt{
                cell.mainLabel.text = "Humidity (\(hum.formatHum())) - \(dateFormatter.string(from: date))"
            } else {
                 cell.mainLabel.text = "Humidity"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "graphInfoCell", for: indexPath) as! GraphCell
            cell.selectionStyle = .none
            
            cell.infoText.text = infoForHumidty(humidity: passedData?.humidity as Double? ?? 0)
            if self.humidityGraph == nil {
                self.humidityGraph = cell.graphView
                self.loadHumidityGraph()
            }

            return cell
        }
    }
}

extension InDetail_VC: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return shortDateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

struct plotPoint {
    var huimidty: Double
    var temperature: Double
    var date : Date
}
