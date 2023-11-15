//
//  InfoDetail.swift
//  AppInfo
//
//  Created by Bryan Andersen on 2023/11/12.
//

import SwiftUI

struct InfoDetail: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var applicationName: String
    @Binding var selectedCategory : String
    @Binding var downloadFee: Int
    @Binding var establishedDate: Date
    @Binding var openHours: Bool
    @Binding var openingHours: Date
    @Binding var closingHours: Date
    @Binding var selectedDays: [Day]
    @Binding var appDetail: String
    @Binding var map_latitude: String
    @Binding var map_longitude: String
    @Binding var displayMap: Bool
    
    @State private var temp_applicationName: String = ""
    @State private var temp_selectedCategory : String = "Social Media"
    @State private var temp_downloadFee: Int = 0
    @State private var temp_establishedDate: Date = Date()
    @State private var temp_openHours: Bool = false
    @State private var temp_openingHours: Date = Date()
    @State private var temp_closingHours: Date = Date()
    @State private var temp_selectedDays: [Day] = []
    @State private var temp_appDetail: String = ""
    
    @State private var showMap: Bool = false
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @Binding var displayInfo: Bool
    @FocusState private var focusedField: Bool
    @State private var showOptions = false
    @State private var showError = false
    
    let category = ["Social Media", "Games", "Education", "Others"]
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 7.0){
            Text("Application Information")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 12)
            HStack{
                VStack(alignment: .leading, spacing: 22){
                    Text("App. Name")
                    Text("App. Category")
                    Text("Download Fee")
                }
                VStack(alignment: .leading){
                    HStack{
                        Divider()
                            .frame(height:35)
                        TextField("Type Here", text: $applicationName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($focusedField)
                    }
                    .onSubmit{
                        focusedField = false
                    }
                    
                    HStack{
                        Divider()
                            .frame(height:35)
                        Picker("Choose Category", selection: $selectedCategory){
                            ForEach(category, id:\.self){index in
                                Text(index)
                            }
                        }
                        .padding(.leading, -10.0)
                        
                    }
                    HStack{
                        Divider()
                            .frame(height:35)
                        Stepper("$\(downloadFee)", value: $downloadFee, in: 0...100, step:1)
                    }
                }
                
            }
            
            DatePicker("Released Date", selection: $establishedDate, displayedComponents: .date)
            
            Toggle("Business Hours", isOn: $openHours)
            
            if openHours{
                Form{
                    HStack {
                        ForEach(Day.allCases, id: \.self) { day in
                            Text(String(day.rawValue.first!))
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(selectedDays.contains(day) ? Color.cyan.cornerRadius(10) : Color.gray.cornerRadius(10))
                                .onTapGesture {
                                    if selectedDays.contains(day) {
                                        selectedDays.removeAll(where: {$0 == day})
                                    } else {
                                        selectedDays.append(day)
                                    }
                                }
                        }
                    }
                    .padding(.leading,-10)
                    .offset(x:20)
                    DatePicker("Opening Hours", selection: $openingHours, displayedComponents: .hourAndMinute)
                    
                    DatePicker("Closing Hours", selection: $closingHours, displayedComponents: .hourAndMinute)
                }
            }
            
            VStack(alignment: .leading){
                Text("Application Information")
                TextEditor(text: $appDetail)
                    .frame(width:350, height:100)
                    .overlay(RoundedRectangle(cornerRadius:10).stroke(lineWidth:2))
            }
            .padding(.leading, -10.0)
            VStack(alignment: .leading){
                Toggle("Map Coordinate", isOn: $displayMap)
                if(displayMap){
                    HStack{
                        TextField("latitude", text: $map_latitude)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numbersAndPunctuation)
                        TextField("longitude", text: $map_longitude)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numbersAndPunctuation)
                    }
                }
            }
            .padding(.top, 5)
            .frame(maxHeight:60)
            Spacer()
            Button("Done", action: {
                if applicationName == "" {
                    displayInfo = false
                    showError = true
                }
                else{
                    displayInfo = true
                    showOptions = true
                }
            })
            .frame(width:200, height:50)
            .background(.bar)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
 
            .alert(isPresented: $showError){
                Alert(title: Text("No Application Name"), message: Text("Please fill in [App. Name]!"), dismissButton: .default(Text("I Understand!"), action:{}))
            }
            .confirmationDialog("Save Changes?", isPresented: $showOptions, titleVisibility: .visible) {
                            Button("Yes") {
                                dismiss()
                            }
                            Button("No") {
                                applicationName = temp_applicationName
                                selectedCategory = temp_selectedCategory
                                downloadFee = temp_downloadFee
                                establishedDate = temp_establishedDate
                                openHours = temp_openHours
                                openingHours = temp_openingHours
                                closingHours = temp_closingHours
                                selectedDays = temp_selectedDays
                                appDetail = temp_appDetail
                                displayMap = showMap
                                map_latitude = latitude
                                map_longitude = longitude
                                dismiss()
                            }
                        }
            .onAppear(){
                temp_applicationName = applicationName
                temp_selectedCategory = selectedCategory
                temp_downloadFee = downloadFee
                temp_establishedDate = establishedDate
                temp_openHours = openHours
                temp_openingHours = openingHours
                temp_closingHours = closingHours
                temp_selectedDays = selectedDays
                temp_appDetail = appDetail
                showMap = displayMap
                latitude = map_latitude
                longitude = map_longitude
            }
            .onChange(of: applicationName){oldValue, newValue in
                if(newValue.count == 0) {
                    displayInfo = false
                }
            }
            .onChange(of: openHours){oldValue, newValue in
                if(newValue == true){
                    openingHours = Date()
                    closingHours = Date()
                    selectedDays = []
                }
            }
            .onChange(of: displayMap){oldValue, newValue in
                if(newValue == false){
                    map_latitude = ""
                    map_longitude = ""
                }
            }
        }
        .padding(.horizontal)
        Spacer()
    }
}

#Preview {
    InfoDetail(applicationName: .constant(String("")), selectedCategory: .constant(String("Social Media")),  downloadFee: .constant(Int(0)), establishedDate: .constant(Date()),openHours: .constant(Bool(true)), openingHours: .constant(Date()), closingHours: .constant(Date()), selectedDays:.constant([Day]([])), appDetail: .constant(String("")), map_latitude: .constant(String("")), map_longitude: .constant(String("")), displayMap: .constant(Bool(false)), displayInfo: .constant(Bool(false)))
}
