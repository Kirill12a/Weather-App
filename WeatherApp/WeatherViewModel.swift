//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Kirill Drozdov on 21.03.2022.
//

import Foundation


private let defualtIcon = "❓"

private let iconMap = ["Drizzle":"🌧", "Thunderstorm":"⛈", "Rain":"🌧", "Clear":"☀️","Clouds":"☁️"]

public class WeatherViewModel: ObservableObject
{
  @Published var cityName: String = "City Name"
  @Published var temperature: String = "--"
  @Published var weatherDescription: String = "--"
  @Published var weatherIcon: String = defualtIcon

  public let weatherService: WeatherService

  public init(weatherService: WeatherService)
  {
    self.weatherService = weatherService
  }

  public func refresh()
  {
    weatherService.loadWeatherData{weather in
      DispatchQueue.main.async {
        self.cityName = weather.city
        self.temperature = "\(weather.temperature)°C"
        self.weatherDescription = weather.description.capitalized
        self.weatherIcon = iconMap[weather.iconName] ?? defualtIcon
      }
    }
  }
}
