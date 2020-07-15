//
//  ContentView.swift
//  OWOneCallExample
//
//  Created by Ringo Wathelet on 2020/07/02.
//

import SwiftUI
import OWOneCall


struct ContentView: View {
    
    let weatherProvider = OWProvider(apiKey: "your key")
    let lang = "en"         // "ja"
    let frmt = "yyyy-MM-dd" // "yyyy年MM月dd日"
    
    @State var weather = OWResponse()
    
    var body: some View {
        VStack (spacing: 40) {
            
            Spacer()
            Text(formattedDate(utc: weather.current?.dt ?? 0))
            Text(weather.current?.weatherInfo() ?? "")
            Image(systemName: weather.current?.weatherIconName() ?? "smiley")
                .resizable()
                .frame(width: 70, height: 65)
                .foregroundColor(Color.green)
            
            Spacer()
            
            if weather.daily != nil {
                ScrollView (.horizontal) {
                    HStack {
                        ForEach(weather.daily!, id: \.self) { daily in
                            VStack {
                                Text(formattedDate(utc: daily.dt))
                                Text(String(format: "%.1f", daily.temp.day)+"°").font(.title)
                                Text("\(daily.weather.first!.weatherDescription.capitalized)")
                            }.fixedSize()
                            Divider().frame(height: 80)
                        }
                    }
                }
            }
            
            Spacer()
            
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        // lat: -33.861536, lon: 151.215206,    //  Sydney
        // lat: 35.661991, lon: 139.762735,     // Tokyo
        
        let myOptions = OWOptions(excludeMode: [.daily, .hourly, .minutely], units: .metric, lang: "en")
        
        // for current and forecast
        weatherProvider.getWeather(lat: 35.661991, lon: 139.762735,
                                        weather: $weather,
                                        options: OWOptions.dailyForecast(lang: lang))
        
        // old style callback
        // weatherProvider.getWeather(lat: 35.661991, lon: 139.762735, options: OWOptions.current()) { response in
        //         if let theWeather = response {
        //            self.weather = theWeather
        //         }
        // }
        
        // for historical data in the past
        // weatherProvider.getWeather(lat: 35.661991, lon: 139.762735,
        //                                  weather: $weather,
        //                                  options: OWHistOptions.yesterday())
    }
    
    func formattedDate(utc: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = frmt
        return dateFormatter.string(from: utc.dateFromUTC())
    }
     
}

