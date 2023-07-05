//
//  SearchLocationView.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import SwiftUI
import MapKit
import FirebaseStorage
import FirebaseFirestore

struct SearchLocationView: View {
    @ObservedObject var manager = LocationManager.shared
    
    @State var navigationTag: String?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 15) {
                    Text("Search Location")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Find locations here", text: $manager.searchText)
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.gray)
                }
                .padding(.vertical, 10)
                
                if let places = manager.fetchedPlaces, !places.isEmpty {
                    List {
                        ForEach(places, id: \.self) { place in
                            
                            Button {
                                if let coordinate = place.location?.coordinate {
                                    manager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                    manager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                    manager.addDraggablePin(coordinate: coordinate)
                                    manager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                }
                                
                                navigationTag = "MAPVIEW"
                                
                            } label: {
                                HStack(spacing: 15) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(place.name ?? "")
                                            .font(.title3.bold())
                                            .foregroundColor(.primary)
                                        
                                        Text(place.locality ?? "")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain )
                } else {
                    Button {
                        if let coordinate = manager.userLocation?.coordinate {
                            manager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                            manager.addDraggablePin(coordinate: coordinate)
                            manager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                            
                            navigationTag = "MAPVIEW"
                        }
                    } label: {
                        Label {
                            Text("Use Current Location")
                                .font(.callout)
                        } icon: {
                            Image(systemName: "location.north.circle.fill")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .background {
                NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                    MapViewSelection()
                } label: {}
                    .labelsHidden()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct SearchLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLocationView()
    }
}

struct MapViewSelection: View {
    @ObservedObject var manager = LocationManager.shared
    @ObservedObject var firebaseManager = FirebaseViewModel()
    @State private var placeName: String = ""
    @State private var description: String = ""
    @State private var city: String = ""
    @State private var selectedType = "Location"
    @State var isFormShowing = false
    @State var showingAlert = false
    @State var selectedImage: UIImage?
    
    var types = ["Location", "Museum", "Restaurant", "Event"]
    
    var body: some View {
        VStack {
            MapViewHelper()
                .ignoresSafeArea()
            
            if let place = manager.pickedPlaceMark {
                VStack(spacing: 15) {
//                    Text("Confirm Location")
//                        .font(.title2.bold())
//                        .foregroundColor(.primary)
//                        .padding(.top)
                    
                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        TextField("Enter title", text: $placeName)
//                            .font(.title3.bold())
//                            .padding(.vertical)
//
//                        TextField("Enter description", text: $description)
//                            .font(.footnote)
//                            .padding(.bottom)
//
//                        TextField("Enter City", text: $city)
//                            .font(.caption)
//                            .padding(.bottom)
//
//                        Picker("Please choose a type", selection: $selectedType) {
//                            ForEach(types, id: \.self) {
//                                Text($0)
//                            }
//                        }
//                        .pickerStyle(.segmented)
//                    }
//                    .foregroundColor(.primary)
                    
                    HStack(spacing: 15) {
//                        Button {
////                            isPickerShowing = true
//                        } label: {
//                            if selectedImage != nil {
//                                Image(uiImage: selectedImage!)
//                                    .resizable()
//                                    .clipShape(Circle())
//                            } else {
//                                Image(systemName: "photo.circle.fill")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .foregroundColor(.accentColor)
//                            }
//                        }
//                        .frame(width: 50, height: 50)
//
                        
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                            
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .foregroundColor(.primary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    
                    Button {
                        
//                        uploadLocation()
                        isFormShowing.toggle()
                        
                        
                    } label: {
                        Text("Confirm Location")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.green)
                            }
                            .overlay(alignment: .trailing) {
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .offset(y: 10)
                }
//                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
//        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
//            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
//        }
        .sheet(isPresented: $isFormShowing, onDismiss: nil) {
            NewLocationFormView(showingAlert: $showingAlert, isFormShowing: $isFormShowing, location: manager.pickedLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        }
        
        .alert("Place added", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        
        .onDisappear {
            manager.pickedLocation = nil
            manager.pickedPlaceMark = nil
            
            manager.mapView.removeAnnotations(manager.mapView.annotations)
        }
    }
    
    func uploadLocation() {
        
        guard selectedImage != nil else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "images/\(UUID().uuidString).jpg"
        let fileref = storageRef.child(path)
        
        let location = Location(name: placeName,
                                cityName: city,
                                coordinates: manager.pickedLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                type: selectedType,
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

struct MapViewHelper: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        return LocationManager.shared.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
