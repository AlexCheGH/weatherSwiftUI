//
//  MapView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/27/21.
//

import MapKit
import SwiftUI
import UIKit


struct Map: UIViewRepresentable {
    @State private var annotation = MKPointAnnotation()
    
    @Binding var coordinate: CGPoint
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = WrappedMap()
        mapView.delegate = context.coordinator
        mapView.onLongPress = addAnnotation(for:)
        
        
        
        return mapView
    }
    
    
    func getCoordinate(from coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(annotation)
    }
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordinate
        annotation = newAnnotation
        self.coordinate = CGPoint(x: coordinate.latitude, y: coordinate.longitude)
    }
    
    
    //MARK:- Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: Map
        init(_ parent: Map) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}


final class WrappedMap: MKMapView {
    var onLongPress: (CLLocationCoordinate2D) -> Void = { _ in }
    
    init() {
        super.init(frame: .zero)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        gestureRecognizer.minimumPressDuration = 0.1
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self)
            let coordinate = convert(location, toCoordinateFrom: self)
                        
            onLongPress(coordinate)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
