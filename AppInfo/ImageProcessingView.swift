//
//  ImageProcessingView.swift
//  AppInfo
//
//  Created by Bryan Andersen on 2023/11/12.
//

import SwiftUI
import PhotosUI


struct ImageProcessingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @Binding var profileImage: Image?
    @State private var showAlert = false
    @State private var alertTitle = ""
    @Binding var offset_x: Double
    @Binding var offset_y: Double
    @Binding var zoomScale: Double
    @State var errorMsg: String = ""
    @State var changeImage = false
    @State var new_offset_x: Double = 0
    @State var new_offset_y: Double = 0
    @State var new_scale: Double = 1
    @State var selectionMade: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Profile Picture Preview")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20.0)
                    .padding(.top, 30.0)
                
                ZStack {
                    if(image != nil){
                        Circle()
                            .stroke(Color.blue, lineWidth: 10)
                            .frame(width:200, height:200)
                        image?
                            .resizable()
                            .scaledToFill()
                            .offset(x:new_offset_x, y:new_offset_y)
                            .scaleEffect(new_scale)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                }
                .toolbar {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Select Profile Picture")
                    }
                }
                .task(id: selectedPhoto) {
                    do{
                        showAlert = false
                        image = try await selectedPhoto?.loadTransferable(type: Image.self)
                        if(image != nil){
                            new_offset_x = 0
                            new_offset_y = 0
                            new_scale = 1
                        }
                    }
                    catch{
                        image = nil
                        showAlert = true
                        errorMsg = "System Error\n\(error.localizedDescription)\n\nPlease choose another image!"
                    }
                } .alert(isPresented: $showAlert) {
                    Alert(title: Text("Unable To Process Image"), message: Text(errorMsg), dismissButton: .default(Text("I Understand!")))
                }
                .padding(.vertical, 30.0)
                
                if image != nil{
                    HStack{
                        VStack(alignment: .leading, spacing: 15.0){
                            Text("Horizontal Slide")
                            Text("Vertical Slide")
                        }
                        VStack(alignment: .leading){
                            Slider(value: $new_offset_x, in: -100...100)
                            Slider(value: $new_offset_y, in: -100...100)
                        }
                    }.padding(.horizontal, 10.0)
                    
                    HStack(spacing: 30.0){
                        Button("Random Scale", action: { new_scale = Double.random(in:1...5)})
                            .foregroundStyle(.white)
                            .frame(width:150, height:30)
                            .background(.tint)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Button("Normal Scale", action:{ new_scale = 1})
                            .foregroundStyle(.white)
                            .frame(width:150, height:30)
                            .background(.tint)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding([.top, .leading, .trailing], 10.0)
                    
                    Button(selectionMade == false ? "Return Page" : "Done", action: {changeImage = true})
                        .frame(width:200, height:50)
                        .background(.bar)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                        .padding(.top, 50.0)
                        .alert(isPresented: $changeImage) {
                            Alert(title: Text("Change Profile Picture"), message: Text("Do you want to save changes?"), primaryButton:.default(Text("Yes"), action: {
                                profileImage = image
                                offset_x = new_offset_x
                                offset_y = new_offset_y
                                zoomScale = new_scale
                                dismiss()
                            }), secondaryButton:.destructive(Text("No"), action:{dismiss()}))
                        }
                }
                else{
                    Spacer(minLength: 340)
                    Button("Return Page", action: {dismiss()})
                        .frame(width:200, height:50)
                        .background(.bar)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                        .padding(.top, 50.0)
                }
                Spacer()
            }
            .padding(.top, 50.0)
            .onChange(of:selectedPhoto){oldValue, newValue in
                selectionMade = true
            }
        }
    }
}


#Preview {
    ImageProcessingView(profileImage: .constant(Image("person")), offset_x: .constant(0.0), offset_y: .constant(0.0), zoomScale: .constant(1.0))
}
