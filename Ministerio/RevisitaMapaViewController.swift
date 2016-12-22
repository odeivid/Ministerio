//
//  RevisitaMapaViewController.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 14/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import MapKit

class RevisitaMapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    
    var gerenciadorLocalizacao = CLLocationManager()
    var contadorUpdateLocation = 0
    var revisitas: [Revisita] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //a propria classa vai cuidar desses objetos
        self.mapa.delegate = self
        MapaGerenciador().configuraGerenciadorLocalizacao(mapaDelegate: self, gerenciadorLocalizacao: gerenciadorLocalizacao)
        
        self.carregarRevisitas()
        self.mostrarRevisitas()
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //verifica se app tem permissao de localizacao
        let alerta = MapaGerenciador().solicitarPermissaoLocalizacaoUsuario(manager: manager, status: status)
        if alerta != nil{
            present(alerta!, animated: true, completion: nil)
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //centraliza
        MapaGerenciador().centralizarNaLocalizacao(gerenciadorLocalizacao: gerenciadorLocalizacao, mapa: self.mapa)
        //para de atualizar localizacao
        gerenciadorLocalizacao.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation  is MKUserLocation{
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        let revisita = (annotation as! RevisitaAnotacao).revisita
        
        if revisita.estudoSimNao {
            pin.pinTintColor = UIColor(colorLiteralRed: (111/255.0), green: (216/255.0), blue: (101/255.0), alpha: 1.0)
        }
        pin.canShowCallout = true
        
        //if let logo = UIImage(named: "logo-apps-foundation-small.jpg") {
        //  pin.detailCalloutAccessoryView = UIImageView(image: logo)
        //}
        
        return pin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: METODOS
    func carregarRevisitas() {
        revisitas = CoreDataRevisita().getRevisitas(ativoSimNao: true)
    }
    
    func mostrarRevisitas() {
        
        for revisita in self.revisitas{
            self.mapa.addAnnotation(RevisitaAnotacao(revisita: revisita))
        }
    }
    
}
