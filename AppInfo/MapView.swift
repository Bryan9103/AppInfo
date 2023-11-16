//
//  MapView.swift
//  AppInfo
//
//  Created by Bryan Andersen on 2023/11/15.
//

import SwiftUI
import MapKit

struct MapView: View {
    var latitude: Double
    var longitude: Double
    var body: some View {
        Map{
            Annotation("Location", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                Image(systemName: "mappin")
                    .padding()
                    .background {
                        Circle()
                            .foregroundStyle(.yellow)
                    }
            }
        }
    }
}



#Preview {
    MapView(latitude: 0, longitude:  0)
}
