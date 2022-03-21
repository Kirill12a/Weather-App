//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Kirill Drozdov on 20.03.2022.
//

import SwiftUI

@main
struct WeatherAppApp: App {
  var body: some Scene {
    WindowGroup {
      let weatherService = WeatherService()
      let viewModel = WeatherViewModel(weatherService: weatherService)
      WeatherView(viewModel: viewModel)
    }
  }
}
