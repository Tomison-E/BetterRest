//
//  ContentView.swift
//  BetterRest
//
//  Created by Lanre ESAN on 26/03/2020.
//  Copyright © 2020 tomisinesan.com. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var wakeUp = defaultWakeTime
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert =  false
    
    let cups = [1,2,3,4,5,6,7,8,9,10]
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("When do you want to wake up").font(.headline)){
                //Text("When do you want to wake up").font(.headline)
                
                DatePicker("please enter a time", selection: $wakeUp,displayedComponents: .hourAndMinute).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep").font(.headline)){
               // Text("Desired amount of sleep").font(.headline)
                Stepper(value: $sleepAmount,in: 4...12, step: 0.25){
                    Text("\(sleepAmount,specifier: "%g") hours")
                    
                }
                }
                 
                Section(header:Text("Daily cofee intake").font(.headline)){
                    Picker(selection: $coffeeAmount,label: Text("Number of cups")){
                    ForEach(0 ..< cups.count) { index in
                        Text("\(self.cups[index]) cups").tag(index)
                    }
                    }
                    
                    Text(alertMessage)
                }
                
                }.navigationBarTitle("Better Rest").navigationBarItems(trailing:
                    Button(action: calc,label:{
                            Text("calculator")
                    })).alert(isPresented: $showingAlert){
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton:.default(Text("OK")))
            }
        }
    }
        static var defaultWakeTime: Date {
            var components = DateComponents()
            components.hour = 7
            components.minute = 0
            return Calendar.current.date(from: components) ?? Date()
        }
    
    
     func calc(){
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do{
            let prediction = try model.prediction(wake:Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is ..."
        }
        catch {
            
            alertTitle = "Error"
            alertMessage = " There was a problem calculating bedtime"
        }
        showingAlert = true;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 Stepper(value: $sleepingAmount, in: 4...12, step: 0.25 ){
            Text("You sleep for \(sleepingAmount, specifier: "%g")")
            }
 */

/*
 struct ContentView: View {
     @State private var sleepingAmount = 8.0
     @State private var wakeUp = Date()
     var body: some View {
         
         VStack {
             
             DatePicker("pick a date", selection:$wakeUp, in: Date()...,displayedComponents: .hourAndMinute).labelsHidden()
         Stepper(value: $sleepingAmount, in: 4...12, step: 0.25 ){
             Text("You sleep for \(sleepingAmount, specifier: "%g")")
             }
         }
     }
 }
 */

/*
 struct ContentView: View {
     @State private var sleepingAmount = 8.0
     @State private var wakeUp = Date()
     
     var body: some View {
         var components = DateComponents()
         components.hour = 8
         components.minute = 0
         let date = Calendar.current.date(from:components) ?? Date()
         return VStack {
             
             DatePicker("pick a date", selection:$wakeUp, in: Date()...,displayedComponents: .hourAndMinute).labelsHidden()
         Stepper(value: $sleepingAmount, in: 4...12, step: 0.25 ){
             Text("You sleep for \(sleepingAmount, specifier: "%g")")
             }
         }
     }
 }
 */

/*
 struct ContentView: View {
     @State private var sleepingAmount = 8.0
     @State private var wakeUp = Date()
     
     var body: some View {
         let components = Calendar.current.dateComponents([.hour,.minute], from: someDate)
         let hour = components.hour ?? 0
         let minute = components.minute ?? 0
         return VStack {
             
             DatePicker("pick a date", selection:$wakeUp, in: Date()...,displayedComponents: .hourAndMinute).labelsHidden()
         Stepper(value: $sleepingAmount, in: 4...12, step: 0.25 ){
             Text("You sleep for \(sleepingAmount, specifier: "%g")")
             }
         }
     }
 }
 */
