//
//  NewLocationFormView.swift
//  Guide
//
//  Created by Vladislav Likh on 13/05/22.
//

import SwiftUI
import CoreLocation
import FirebaseStorage
import FirebaseFirestore
import UIKit
struct NewLocationFormView: View {
    @ObservedObject var firebaseManager = FirebaseViewModel()
    @Binding var showingAlert: Bool
    @Binding var isFormShowing: Bool
    @State var isPickerShowing = false
//    @State var showingAlert = false
    @State var cityName: String = "Неаполь"
    @State var title: String = ""
    @State var description: String = ""
    @State var type: String = "Location"
    @State var image: UIImage? = UIImage(named: "emptyImage")
    var location: CLLocationCoordinate2D
    var fieldsReady: Bool { title != "" && description != "" && cityName != "" && image != nil}
    var types = ["Location", "Museum", "Restaurant", "Event"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("Fill the fucking form")
                    .font(.title.bold())
                    .foregroundColor(.black)
                Spacer()
                Button {isFormShowing.toggle()} label: {
                    Image(systemName: "multiply.circle")
                        .font(.system(size: 26))
                }
                .accentColor(.black)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.gray.opacity(0.1))
                .frame(height: 55)
                .overlay(
                    TextField("City name", text: $cityName)
                        .font(.headline)
                        .padding()
                )
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.gray.opacity(0.1))
                .frame(height: 55)
                .overlay(
                    TextField("Place title", text: $title)
                        .font(.headline)
                        .padding()
                )
            
            
            Picker("Please choose a type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.gray.opacity(0.1))
                .frame(height: 55)
                .overlay(
                        TextField("Description", text: $description)
                            .font(.headline)
                            .padding()
                            .background(.clear)
                            .foregroundColor(.black)
//                            .padding(.leading, -5)
//                            .padding(.top, -8)
                )
            
            Button {
                isPickerShowing = true
            } label: {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .aspectRatio(16/9, contentMode: .fit)
                .foregroundColor(.gray.opacity(0.1))
                .overlay(
                    Button {
                        isPickerShowing = true
                    } label: {
                        if image == nil {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 180, height: 55)
                                .foregroundColor(.green)
                                .overlay(
                                    Label("Take a photo", systemImage: "camera")
                                        .foregroundColor(.white)
                                        .font(.body.bold())
                                    //                            VStack(spacing: 5) {
                                    //                                Image(systemName: "photo.on.rectangle.angled")
                                    //                                    .font(.system(size: 25, weight: .light))
                                    //                                Text("Add photo")
                                    //                                    .font(.body.bold())
                                    //                            }.foregroundColor(.white)
                                )
                        } else {
                            Image(uiImage: image ?? UIImage())
                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                                .aspectRatio(contentMode: .fit)
//                                .mask(
//                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                        .padding(.horizontal, 20)
//                                )

//                                .scaledToFill()
//                                .mask(
//                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                )
                        }
                    }
                )
            }

            
            Spacer()
            
            Button {
                uploadLocation()
                isFormShowing = false
                showingAlert = true
                
            } label: {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .frame(height: 60)
                    .foregroundColor(.green)
                    .overlay(
                        Label("Send place", systemImage: "plus")
                            .font(.body.bold())
                            .foregroundColor(.white)
                    )
            }
            .opacity(fieldsReady ? 1 : 0)
            
        }
        .padding(20)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $image, isPickerShowing: $isPickerShowing)
        }
//        .alert("Place added", isPresented: $showingAlert) {
//            Button("OK", role: .cancel) { }
//        }

    
    }
    
    func uploadLocation() {
        
        guard image != UIImage() else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        let imageData = image!.jpegData(compressionQuality: 0.5)
        
        guard imageData != nil else {
            return
        }
        
        let path = "images/\(UUID().uuidString).jpg"
        let fileref = storageRef.child(path)
        
        let location = Location(name: title,
                                cityName: cityName,
                                coordinates: location,
                                type: type,
                                description: description,
                                imageURL: path)
        
        let uploadTask = fileref.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil {
                firebaseManager.addPin(location: location)
                print("added item")
            }
        }
    }
}

struct NewLocationFormView_PreviewsView: View {
    @State var showingAlert2 = true
    @State var isFormShowing2 = true
    var body: some View {
        NewLocationFormView(showingAlert: $showingAlert2, isFormShowing:  $isFormShowing2, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    }
}

struct NewLocationFormView_Previews: PreviewProvider {
    @State var isFormShowing = true
    static var previews: some View {
        NewLocationFormView_PreviewsView()
//            .environmentObject(FirebaseViewModel())
            .previewDevice("iPhone 12")
            
    }
}
