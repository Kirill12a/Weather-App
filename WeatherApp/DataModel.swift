//
//  DataModel.swift
//  WeatherApp
//
//  Created by Kirill Drozdov on 21.03.2022.
//

import Foundation
struct APIResponse: Decodable
{
  let name: String
  let main: APIMain
  let weather: [ApiWeather]
}


struct APIMain: Decodable
{
  let temp: Double
}

struct ApiWeather: Decodable
{
  let description: String
  let icon: String

  enum CodingKeys: String, CodingKey
  {
    case description
    case icon = "main"
  }
}

