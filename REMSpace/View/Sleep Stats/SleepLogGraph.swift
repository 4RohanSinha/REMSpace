//
//  SleepLogGraph.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/12/23.
//

import UIKit
import SwiftUI

struct SleepLogGraph: View {
    var sleepLogs: [SleepLogEntry] = []
    var currentSleepLogIdx: Int?
    var onLogTap: ((Int) -> ())?
    
    init(sleepLogs: [SleepLogEntry], currentSleepLogIdx: Int?, onLogTap: ((Int) -> ())?) {
        self.sleepLogs = sleepLogs
        self.sleepLogs.sort { $0.date! < $1.date! }
        self.currentSleepLogIdx = currentSleepLogIdx ?? (sleepLogs.count - 1)
        self.onLogTap = onLogTap
    }
    
    
    
    var body: some View {
        VStack {
            Text("Sleep Score (1-100)")
                .fontWeight(.bold)
                .underline()
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        SleepLogGraphLine(logDataPoints: sleepLogs)
                            .stroke(Color.indigo, lineWidth: 2.0)
                            .foregroundColor(Color.clear)
                        SleepLogGraphDataPoints(dataPoints: sleepLogs, highlightEntry: sleepLogs[currentSleepLogIdx ?? (sleepLogs.count - 1)], rectDimensions: (width: geometry.size.width, height: geometry.size.height), onLogTap: onLogTap)
                        
                    }
                }
            }
            .background(Color.init(uiColor: .systemGray6))
            
            Text("Date")
                .fontWeight(.light)
        }
    }
}

struct SleepLogGraphDataPoint: Shape {
    var point: (CGFloat, CGFloat)
    var isHighlighted: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if isHighlighted {
            path.addEllipse(in: CGRect(x: point.0-10, y: point.1-10, width: 20, height: 20))
        } else {
            path.addEllipse(in: CGRect(x: point.0-4, y: point.1-4, width: 8, height: 8))
        }
        
        return path
    }
}

struct SleepLogGraphDataPoints: View {
    var dataPoints: [SleepLogEntry]
    var highlightEntry: SleepLogEntry
    var rectDimensions: (width: Double, height: Double)
    var onLogTap: ((Int) -> ())?
    
    var body: some View {
        ForEach(dataPoints) { logEntry in
            let tap = TapGesture()
                .onEnded { _ in
                    if let ind = dataPoints.firstIndex(of: logEntry) {
                        print(ind)
                        onLogTap?(ind)
                    }
                }
            
            VStack {
                if logEntry == highlightEntry {
                    SleepLogGraphDataPoint(point: getPointCoordinates(logEntry: logEntry), isHighlighted: true)
                        .fill(Color.purple)
                        .gesture(tap)
                } else {
                    SleepLogGraphDataPoint(point: getPointCoordinates(logEntry: logEntry), isHighlighted: false)
                        .fill(Color.indigo)
                        .gesture(tap)
                }
            }
        }
    }
    
    func getPointCoordinates(logEntry: SleepLogEntry) -> (xCoordinate: CGFloat, yCoordinate: CGFloat) {
        let xIncrement = ((rectDimensions.width - 20) / (CGFloat(dataPoints.count) - 1))
        let index = dataPoints.firstIndex(of: logEntry) ?? 0
        let xCoordinate = 10 + Double(index) * Double(xIncrement)
        let yCoordinate = 20 + (1 - (Double(logEntry.sleepScore)/100)) * Double(rectDimensions.height) * 0.8
        return (xCoordinate, yCoordinate)
    }
}

struct SleepLogGraphLine: Shape {
    var logDataPoints: [SleepLogEntry]
    
    func path(in rect: CGRect) -> Path {
        let sleepScores = logDataPoints.map { Double($0.sleepScore) }
        let adjustedSleepScores = sleepScores.map { 1.0 - ($0/100.0) }
        let xIncrement = ((rect.width - 20) / (CGFloat(adjustedSleepScores.count) - 1))
        
        var path = Path()

        path.move(to: CGPoint(x: 10.0, y: 20 + adjustedSleepScores[0] * Double(rect.height) * 0.8))
        
        for i in 1..<adjustedSleepScores.count {
            let pt = CGPoint(x: 10 + Double(i)*Double(xIncrement), y: 20 + adjustedSleepScores[i] * Double(rect.height) * 0.8)
            
            path.addLine(to: pt)
        }
                                
        return path
    }
}
