//
//  MapView.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseStorage
import SDWebImageSwiftUI

struct MapView: View {
    
    @State var imageURL = URL(string: "")
    @EnvironmentObject private var vm: MapViewModel
    @EnvironmentObject private var toursVM: ToursViewModel
    
    @State var showSheet: Bool = false
        
    var body: some View {
        NavigationView {
            ZStack {
                mapLayer
                    .ignoresSafeArea()
                    .onAppear {
                        vm.requestNotifications()
                        vm.showUserLocation(coordinates: LocationManager.shared.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                        print(vm.currentPlace?.name)
                    }
                
                VStack {
                    header
                        .padding()
                }
            }
            .navigationTitle("")
            .halfSheet(showSheet: $showSheet) {
                PlaceInfoView(image: Image(vm.currentPlace?.name ?? "emptyImage"), title: vm.currentPlace?.name ?? "", description: vm.currentPlace?.description ?? "")
//                VStack {
//                    Text(vm.currentPlace?.name ?? "")
//
//                    Button {
//                        showSheet.toggle()
//                    } label: {
//                        Text("Close")
//                            .foregroundColor(.red)
//                    }
//                    .padding()
//                }
            } onEnd: {
                vm.currentPlace = nil
            }
            .onChange(of: vm.currentPlace?.name, perform: { newValue in
                if newValue != nil {
                    showSheet = true
                } else {
                    showSheet = false
                }
            })
            .navigationBarHidden(true)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
//            .environmentObject(FirebaseViewModel())
            .environmentObject(ToursViewModel())
    }
}

extension MapView {
    
    private var mapLayer: some View {
        Map(
            coordinateRegion: $vm.mapRegion,
            showsUserLocation: true,
            annotationItems: toursVM.listOfPlaces,
            annotationContent: { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)) {
                    MapAnnotationView()
                        .scaleEffect(vm.currentPlace == location ? 1 : 0.7)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.showLocation(place: location)
                                vm.mapRegion.center = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
                            }
                        }
                }
            }
        )
        .onAppear {
            for place in toursVM.listOfPlaces {
                print(place.name)
            }
        }
    }
    
    private var header: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button {
                        print("Info")
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title2)
                    }
                    .padding()
                    
                    Divider()
                        .frame(maxWidth: 58)
                    
                    Button {
                        vm.showUserLocation(coordinates: LocationManager.shared.userLocation!.coordinate)
                        vm.currentPlace = nil
                    } label: {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    .padding()
                }
                .background(.thickMaterial)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            Spacer()
        }
    }
    
//    private var footer: some View {
//        PlaceInfoView(image: WebImage(url: imageURL), title: vm.currentPlace?.name ?? "", description: vm.currentPlace?.description ?? "")
//    }
}

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()-> SheetView, onEnd: @escaping ()->())->some View {
        return self
            .background(HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd))
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(), .large()]
            
            presentationController.prefersGrabberVisible = true
        }
    }
}
