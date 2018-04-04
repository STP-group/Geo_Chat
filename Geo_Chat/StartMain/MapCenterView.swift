//
//  MapCenterView.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 03.04.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public class MapLogo {
    
    public func pointMarkToMaps(mapView: MKMapView,guestUserCortinate: CLLocationCoordinate2D, userLocationLatitude: Double) {
        
        // Присвоение кординат комнаты для расчета растояния
        let locationRoom = CLLocation(latitude: userLocationLatitude, longitude: userLocationLongitude)
        // Присвоение кординат пользователя для расчета растояния
        let locationGuest = CLLocation(latitude: guestUserCortinate.latitude, longitude: guestUserCortinate.longitude)
        // Вычисляем расстояние между комнатой и пользователем
        let distanceInMeters = locationRoom.distance(from: locationGuest)
        
        // переводим в целое число ( пример: из 513.212405045983 в 513 )
       // let subTitleText = "\(distanceInMeters)".components(separatedBy: ".")
        
        // Ставим точку на карте ( для тестирования )
        let placeMarkPointAnotation = MKPointAnnotation()
        // Имя точки
        placeMarkPointAnotation.title = "Я тут"
        // Растояние отображается на точке ( смотреть чуть выше )
        //7           placeMarkPointAnotation.subtitle = "\(subTitleText[0])m"
        
        // Точка на карте - используется кординаты комнаты
        placeMarkPointAnotation.coordinate.latitude = userLocationLatitude
        placeMarkPointAnotation.coordinate.longitude = userLocationLongitude
        //roomCordinates
        // принт расстояния
        print("растояние \(distanceInMeters)")
        if distanceInMeters >= 500.0 {
            print(">500")
        } else {
            print("<500")
        }
        
        // отображение на карте
        mapView.showAnnotations([placeMarkPointAnotation], animated: true)
        mapView.selectAnnotation(placeMarkPointAnotation, animated: true)
    }
    
    public func createPin(mapView: MKMapView){
        
        //Access user Location LAT & LON from User Defaults
        let coordinate =  CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "LAT") as! CLLocationDegrees, longitude: UserDefaults.standard.value(forKey: "LON") as! CLLocationDegrees)
        var region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        region.center = coordinate
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
}
