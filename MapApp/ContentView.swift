//
//  ContentView.swift
//  MapApp
//
//  Created by Syaam Boss on 4/23/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State var tex = ""
    @State var x = [""]
    
    var body: some View{
        NavigationView{
            ZStack{
                //shows the map on the screen
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true).ignoresSafeArea().accentColor(Color(.systemPink)).onAppear{
                    viewModel.checkLocationServices()
                    
                }//this call was created with Sean Allen's video
                //shows the searching view in order to choose where the user wants to go
                NavigationLink(destination: SearchBarView(), label: {
                    ZStack{
                        Circle().fill(Color.black).frame(width: 40, height: 40,alignment: Alignment.init(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.top))
                        Image(systemName:"magnifyingglass")
                    }
                }).offset(x:140,y:-315)
                ZStack{
                    //creates bottom part that asks if they want to go to the planning view, which includes the notes tab and planning features
                    Rectangle().fill(Color.white).frame(height: 150,alignment: Alignment.init(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.top)).offset(y:320)
                    HStack{
                        NavigationLink(destination: PlanningView(), label: {
                            Text("Planning").font(.system(size: 25))
                        }).offset(x:-75,y:320)
                        Text("Map").font(.system(size: 25)).offset(x:40,y:320)
                    }
                }
            }
        }
        
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
//view that is called once you ask the user for the planning tab
struct PlanningView: View{
    @State var tx: String = UserDefaults.standard.string(forKey: "TEXT_KEY") ?? ""
    let ordering = ["","","","","","","","","",""]
    @State var inputText: String = ""
    @State var boo = false
    @State var count = 1
    @State var orderText1: String = ""
    @State var orderText2: String = ""
    @State var orderText3: String = ""
    @State var orderText4: String = ""
    @State var orderText5: String = ""
    @State var orderText6: String = ""
    @State var orderText7: String = ""
    @State var orderText8: String = ""
    @State var orderText9: String = ""
    @State var orderText10: String = ""
    @State var counter = 1
    var body: some View{
        ScrollView{
            VStack{
                //in the planning view, this shows the listing of their plans in step form
                NavigationLink(destination: {
                    List{
                        
                        TextField("1. ", text: $orderText1)
                        TextField("2. ", text: $orderText2)
                        TextField("3. ", text: $orderText3)
                        TextField("4. ", text: $orderText4)
                        TextField("5. ", text: $orderText5)
                        TextField("6. ", text: $orderText6)
                        TextField("7. ", text: $orderText7)
                        TextField("8. ", text: $orderText8)
                        TextField("9. ", text: $orderText9)
                        TextField("10. ", text: $orderText10)
                        
                    }
                }, label: {
                    Text("List")
                    
                }).offset(x: 125)
                ZStack{
                    //sets up feature to save the text in the notes tab
                    Rectangle().frame( height: 575).foregroundColor(Color("SearchBar")).cornerRadius(13).padding()
                    if(tx.isEmpty){
                        
                        TextField("", text : $tx).foregroundColor(Color.black).navigationTitle("Notes").offset(x: 30,y:-250).disabled(true)
                        TextField("", text : $inputText).foregroundColor(Color.black).navigationTitle("Notes").offset(x: 30,y:-250).disabled(false)
                    }
                    else if(boo){
                        TextField("", text : $inputText).foregroundColor(Color.black).navigationTitle("Notes").offset(x: 30,y:-250).disabled(false)
                        TextField("", text : $tx).foregroundColor(Color.black).navigationTitle("Notes").offset(x: 30,y:-250).disabled(true)
                    }
                    else{
                        TextField("", text : $tx).foregroundColor(Color.black).navigationTitle("Notes").offset(x: 30,y:-250).disabled(false)
                        TextField("", text : $inputText).foregroundColor(Color.black).navigationTitle("Notes").offset(x: 30,y:-250).disabled(true)
                        
                    }
                    
                    
                    Spacer()
                }
                Button("Save"){
                    if(tx.isEmpty){
                        UserDefaults.standard.set(inputText,forKey: "TEXT_KEY")//method calls were learned about from a youtube video on UserDefaults
                        tx = inputText
                        boo = true
                    }
                    else if (count % 2 == 0){
                        UserDefaults.standard.set(inputText,forKey: "TEXT_KEY")
                        tx = inputText
                        boo = true
                    }else{
                        UserDefaults.standard.set(tx,forKey: "TEXT_KEY")
                        inputText = tx
                        boo = false
                    }
                    count+=1
                    
                }
                
                
            }
        }
    }
}
//struct allows searching to happen through its algorithm to search and buttons that open up to a new view that shows the directions
struct SearchBarView: View{
    
    let locations = ["White House","Lake Braddock","Statue of Liberty","Apple Park","The Pentagon", "United States Capitol", "Lincoln Memorial", "Empire State Building", "Space Needle"]
    @State var searchText=""
    var body: some View{
        VStack{
            
            SearchView(searchText: $searchText)
            //algorithm to search for what location they want based on the letters in the string, inspired from a video I watched about the SearchBar.
            List{
                ForEach(locations.sorted().filter({
                    (loc: String)-> Bool in
                    return loc.hasPrefix(searchText) || searchText == ""
                }), id: \.self) { loc in
                    NavigationLink(destination: {
                        RouteView(location: loc)
                        
                    }, label: {
                        Text(loc)
                    })
                }
            }
        }.listStyle(GroupedListStyle())
            .navigationTitle(Text("Locations"))
        
        
    }
}
struct SearchBarView_Preview: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}


struct SearchView: View{
    @Binding var searchText:String
    var body: some View{
        //the actual textfield that opens up once they want to search for a particular location
        ZStack{
            Rectangle().foregroundColor(Color("SearchBar"))
            HStack{
                Image(systemName: "magnifyingglass").offset(x:10)
                TextField("Enter Location",text:$searchText).offset(x:5)
            }}.foregroundColor(Color.gray).frame(height: 40).cornerRadius(13).padding()
        
    }
}
struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant(""))
    }
    
}
//struct that creates the request to show the locations, inspired by a video I had watched by Ale Patron
struct RouteView: View{
    @StateObject var viewModel = ContentViewModel()
    let coordinateMap = ["White House":CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), "Lake Braddock":CLLocationCoordinate2D(latitude: 38.8011, longitude: -77.2718), "Statue of Liberty":CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445),"Apple Park":CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),"The Pentagon":CLLocationCoordinate2D(latitude: 38.8719, longitude: 77.0563), "United States Capitol Building":CLLocationCoordinate2D(latitude: 38.8899, longitude: 77.0091), "Lincoln Memorial":CLLocationCoordinate2D(latitude: 38.8893, longitude: 77.0502), "Empire State Building":CLLocationCoordinate2D(latitude: 40.7484, longitude: 73.9857), "Space Needle":CLLocationCoordinate2D(latitude: 47.6205, longitude: 122.3493)]
    var location:String
    @State private var directions: [String] = []
    @State private var showDirections = false
    var locationManager = CLLocationManager()
    var body: some View {
        //method body was created with a youtube video I had watched on showing directions from two locations (Ale Patron)
        VStack {
            MapView(directions: $directions, startCoordinate: locationManager.location!.coordinate, endCoordinate: coordinateMap.values[coordinateMap.keys.firstIndex(of: location)!])
            
            Button(action: {
                self.showDirections.toggle()
            }, label: {
                Text("Show directions")
            })
            .disabled(directions.isEmpty)
            .padding()
        }.sheet(isPresented: $showDirections, content: {
            VStack(spacing: 0) {
                Text("Directions")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Divider().background(Color(UIColor.systemBlue))
                
                List(0..<self.directions.count, id: \.self) { i in
                    Text(self.directions[i]).padding()
                }
            }
        })
        //method call above searches through the map and finds the location they enter into the textfield. It then finds the value associated with that key and returns the latitude and longitude of the location they want. I send this value through to the method and it creates the request to find directions between the user's current location and that longtiude/latitude.
        
    }
}
// created all with Ale Patron's video
struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var directions: [String]
    var startCoordinate : CLLocationCoordinate2D
    var endCoordinate : CLLocationCoordinate2D
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(
            center: startCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        let p1 = MKPlacemark(coordinate: startCoordinate)
        let p2 = MKPlacemark(coordinate: endCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([p1, p2])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                animated: true)
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}
