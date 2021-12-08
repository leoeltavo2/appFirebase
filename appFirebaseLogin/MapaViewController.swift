//
//  MapaViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 06/12/21.
//

import UIKit
import CoreLocation
import MapKit

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    //hacer uso del GPS
    var manager = CLLocationManager();
    
    var lat: CLLocationDegrees!
    var long: CLLocationDegrees!
    
    @IBOutlet weak var barraBusqueda: UISearchBar!
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barraBusqueda.delegate = self
        mapa.delegate = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        //mejorar la presicion de la localizacion
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //monitorear en todo momento la localizacion
        manager.startUpdatingLocation()
        
        //localizacion estatica de la tienda
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 19.699847866531833, longitude: -101.1895947381785)
            annotation.title = "DonSazon"
            annotation.subtitle = "Sucursal DonSazon"
            mapa.addAnnotation(annotation)
        
    }

    
    //MARK: - obtener localizacion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacion: CLLocationCoordinate2D = manager.location!.coordinate
        //nivel de zoom que queramos
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        self.mapa.setRegion(region, animated: true)
        self.mapa.showsUserLocation = true

    }
    
    
    //MARK: - Trazar la ruta
    func trazarRuta(coordenadasDestino: CLLocationCoordinate2D){
        guard let coordinadasOrigen = manager.location?.coordinate else {return}
        
        //crear lugar de origen y destino
        let lugarOrigenMark = MKPlacemark(coordinate: coordinadasOrigen)
        let lugarDestinoMark = MKPlacemark(coordinate: coordenadasDestino)
        
        //crear objeto mapkit Item
        let lugarOrigenItem = MKMapItem(placemark: lugarOrigenMark)
        let lugarDestinoItem = MKMapItem(placemark: lugarDestinoMark)
        
        //solicitar la ruta
        let solicitudDestino = MKDirections.Request()
        solicitudDestino.source = lugarOrigenItem
        solicitudDestino.destination = lugarDestinoItem
        
        //como se va a viajar
        solicitudDestino.transportType = .any
        solicitudDestino.requestsAlternateRoutes = true
        
        let direcciones = MKDirections(request: solicitudDestino)
        direcciones.calculate { (respuesta, error) in
            guard let respuestaSegura = respuesta else{
                if let error = error{
                    print("Error al calcular la ruta \(error.localizedDescription)")
                }
                return
            }
            //si se calculo la ruta
            print(respuestaSegura.routes.count)
            let ruta = respuestaSegura.routes[0]
            
            
            //superponer el mapa
            self.mapa.addOverlay(ruta.polyline)
            self.mapa.setVisibleMapRect(ruta.polyline.boundingMapRect, animated: true)
        }
    }
    
    //MARK: - Mostrar ruta encima del mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderizado = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderizado.strokeColor = .magenta
        return renderizado
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "ERROR EN LA DIRECCIÓN", message: "La dirección no fue encontrada", preferredStyle: .alert)
        
        
        let Aceptar = UIAlertAction(title: "Aceptar", style: .default)
    
        alerta.addAction(Aceptar)
        
        self.present(alerta, animated: true)
    }

}


extension MapaViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        barraBusqueda.resignFirstResponder()
        let geocoder = CLGeocoder()
        
       // if let direccion = barraBusqueda.text{
            geocoder.geocodeAddressString(barraBusqueda.text!) { (places:[CLPlacemark]?, error: Error?) in
                
                //crear ruta destino
                guard let destinoRuta = places?.first?.location else {return}
                
                if error == nil{
                    //mostrar la direccion
                    let place = places?.first
                
                    let anotacion = MKPointAnnotation()
                    anotacion.coordinate = (place?.location?.coordinate)!
                    anotacion.title = self.barraBusqueda.text!
                    //nivel de zoom que queramos
                    let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                    let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
                    //borrar las rutas
                    let overlays = self.mapa.overlays
                    let annotations = self.mapa.annotations
                    self.mapa.removeOverlays(overlays)
                    self.mapa.removeAnnotations(annotations)
                    
                    self.mapa.setRegion(region, animated: true)
                    self.mapa.addAnnotation(anotacion)
                    self.mapa.selectAnnotation(anotacion, animated: true)
                    
                    //mandar llamar trazar ruta
                    
                    self.trazarRuta(coordenadasDestino: destinoRuta.coordinate)
                    
                }else{
                    let alerta = UIAlertController(title: "ERROR EN LA DIRECCIÓN", message: "La dirección '\(self.barraBusqueda.text!)' no fue encontrada", preferredStyle: .alert)
                    
                    
                    let Aceptar = UIAlertAction(title: "Aceptar", style: .default)
                
                    alerta.addAction(Aceptar)
                    
                    self.present(alerta, animated: true)
                }
            }

        //}
        
        
    }
}




//boton cambiar de mapa
//@IBAction func btnCambiarMapa(_ sender: UISegmentedControl) {
//    switch selector.selectedSegmentIndex {
//    case 0:
//        self.mapa.mapType = .standard
//    case 1:
//        self.mapa.mapType = .satellite
//    case 2:
//        self.mapa.mapType = .hybrid
//    default:
//        break
//    }
//}
