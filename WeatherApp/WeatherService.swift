//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Kirill Drozdov on 20.03.2022.
//

import Foundation
import CoreLocation

public final class WeatherService: NSObject
{
  private let locationManager = CLLocationManager()
  private let API_KEY = "180ee8915bfc757e703e47abc720550f"
  private var comletionHandler: ((Weather)->Void)?

  public override init() {
    super.init()
    locationManager.delegate = self
  }

  public func loadWeatherData(_ comletionHandler:@escaping((Weather)->Void))
  {
    self.comletionHandler = comletionHandler
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }

  // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
  private func makeDataRequest(forCoordinates cordinates: CLLocationCoordinate2D)
  {
    guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(cordinates.latitude)&lon=\(cordinates.longitude)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}

    guard let url = URL(string: urlString) else {return}

    URLSession.shared.dataTask(with: url) { data, response, error in
      guard error == nil, let data = data else {return}
      if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
        self.comletionHandler?(Weather(response: response))
      }
    }.resume()
  }

}


extension WeatherService: CLLocationManagerDelegate
{
  public func locationManager(_ manager: CLLocationManager, didUpdateLications locations: [CLLocation ])
  {
    guard let location = locations.first else {return}
    makeDataRequest(forCoordinates: location.coordinate)
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
  {
    print("Erorr \(error.localizedDescription)")
  }
}

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
  let iconName: String

  enum CodingKeys: String, CodingKey
  {
    case description
    case iconName = "main"
  }
}
