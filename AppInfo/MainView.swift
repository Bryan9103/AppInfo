//
//  MainView.swift
//  AppInfo
//
//  Created by Bryan Andersen on 2023/11/12.
//

import SwiftUI
import MapKit

enum Day: String, CaseIterable {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

struct MainView: View {
    @State private var showFullScreenCover = false
    
    @State private var profileImage: Image?  = Image(systemName: "person")
    @State private var offset_x :Double = 0.0
    @State private var offset_y :Double = 0.0
    @State private var zoomScale: Double = 1.0
    @State private var bgColor = Color(uiColor: UIColor.systemBackground)
    
    @State private var presentSheet = false
    @State private var applicationName = ""
    @State private var selectedCategory = "Social Media"
    @State private var downloadFee: Int = 0
    @State private var establishedDate: Date = Date()
    @State private var openHours: Bool = false
    @State private var openingHours: Date = Date()
    @State private var closingHours: Date = Date()
    @State private var selectedDays: [Day] = []
    @State private var appDetail: String = ""
    
    @State private var mapAvailable: Bool = false
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var viewData = false
    @State private var showMap = false
    
    let languages = ["Chinese", "English"]
    var body: some View {
        VStack(){
            ColorPicker("Set Background Color", selection: $bgColor, supportsOpacity: true)
                .padding(.horizontal)
            
            VStack(){
                Button("Edit Application Information"){
                    presentSheet = true
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(.blue)
                .clipShape(.buttonBorder)
                .padding(.leading, 100)
                .sheet(isPresented:$presentSheet){ InfoDetail(applicationName: $applicationName, selectedCategory: $selectedCategory, downloadFee: $downloadFee, establishedDate:$establishedDate, openHours: $openHours, openingHours: $openingHours, closingHours: $closingHours, selectedDays : $selectedDays, appDetail: $appDetail,  map_latitude: $latitude, map_longitude: $longitude, displayMap: $mapAvailable, displayInfo: $viewData)
                }
            }
            
            VStack(alignment: .center){
                Button(action: {showFullScreenCover = true}, label: {
                    ZStack{
                        Circle()
                            .stroke(.linearGradient(colors: [.blue,.yellow, .green], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 10)
                            .frame(width:200, height:200)
                        
                        if profileImage == Image(systemName: "person"){
                            profileImage?
                                .resizable()
                                .scaledToFill()
                                .frame(width:130, height:130)
                                .frame(width: 200, height: 200)
                                .background(.background)
                                .clipShape(Circle())
                        }
                        else{
                            profileImage?
                                .resizable()
                                .scaledToFill()
                                .offset(x:offset_x, y:offset_y)
                                .scaleEffect(zoomScale)
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                })
                .fullScreenCover(isPresented: $showFullScreenCover)
                { ImageProcessingView(profileImage: $profileImage, offset_x: $offset_x, offset_y: $offset_y, zoomScale: $zoomScale)}
                .padding(.all) }
            
            if(viewData){
                LazyVStack{
                    Text(applicationName)
                        .font(.system(size:40))
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(selectedCategory)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Divider()
                        .frame(width: 300, height:5)
                        .background(.black)
                    
                    Text("Application Information")
                        .font(.system(size:25))
                    
                    VStack{
                        ScrollView(.vertical){
                            LazyVStack(alignment: .leading){
                                LazyHStack{
                                    Text("Download Fee")
                                    Spacer(minLength:20)
                                    Divider()
                                        .frame(width: 3)
                                        .overlay(.blue)
                                    if(downloadFee == 0){
                                        Text("Free")
                                    }else{
                                        Text("\(downloadFee) NTD")
                                    }
                                }
                                LazyHStack{
                                    Text("Released Date")
                                    Spacer(minLength:18)
                                    Divider()
                                        .frame(width: 3)
                                        .overlay(.blue)
                                    Text(establishedDate, format: .dateTime.day().month().year())
                                }
                                
                                if(openHours == true && selectedDays.count > 0){
                                    LazyHStack{
                                        Text("Service Days")
                                        Spacer(minLength:30)
                                        Divider()
                                            .frame(width: 3)
                                            .overlay(.blue)
                                        if(selectedDays.count == 7){
                                            Text("Everyday")
                                        }
                                        else if(selectedDays.count == 2 && selectedDays.contains(Day.Sunday) && selectedDays.contains(Day.Saturday)){
                                            Text("Weekends")
                                        }
                                        else if(selectedDays.count == 5 && !selectedDays.contains(Day.Sunday) && !selectedDays.contains(Day.Saturday)){
                                            Text("Weekdays")
                                        }
                                        else{
                                            ForEach(selectedDays, id: \.self) { day in
                                                Text(String(day.rawValue.prefix(3)))
                                            }
                                        }
                                    }
                                    LazyHStack{
                                        Text("Service Hours")
                                        Spacer(minLength:22)
                                        Divider()
                                            .frame(width: 3)
                                            .overlay(.blue)
                                        Text(openingHours, format: .dateTime.hour().minute()) + Text (" - ") + Text(closingHours, format: .dateTime.hour().minute())
                                    }
                                }
                                
                                if(appDetail != ""){
                                    HStack(alignment: .top){
                                        Text("Detail")
                                            .padding(.trailing, 77.0)
                                        Divider()
                                            .frame(minHeight:22)
                                            .frame(width: 3)
                                            .overlay(.blue)
                                        VStack{
                                            Text(appDetail)
                                                .lineLimit(nil)
                                        }
                                    }
                                }
                                
                                DisclosureGroup("Available Languages") {
                                    VStack(alignment: .leading) {
                                        ForEach(languages, id: \.self) { language in
                                            Text(language)
                                        }
                                    }
                                }
                                .foregroundStyle(.black)
                                
                                if(mapAvailable && longitude.doubleValue != nil && latitude.doubleValue != nil){
                                    if let lonDouble = Double(longitude), let latDouble = Double(latitude) {
                                        Button("Show Location") {
                                            showMap.toggle()
                                        }
                                        .sheet(isPresented: $showMap) {
                                            Text("Office")
                                            MapView(latitude: latDouble, longitude: lonDouble)
                                                .presentationDetents([.height(300)])
                                        }
                                    }
                                    
                                }
                            }
                            Spacer()
                            
                        }
                        .frame(minWidth: 300, minHeight: 300)
                        .padding(.all, 10)
                        .frame(width:370, height: 300)
                    }
                }
                .background(.white)
                .border(.black)
                
            }
            Spacer()
        }
        .padding(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgColor)
    }
}

extension String {
    struct NumFormatter {
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }
}

#Preview {
    MainView()
}
