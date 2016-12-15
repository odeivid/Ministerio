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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //a propria classa vai cuidar desses objetos
        mapa.delegate = self
        configuraGerenciadorLocalizacao()
        
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //se nao foi autorizado usar a localizacao
        if status != .authorizedWhenInUse && status != .notDetermined{
            let alerta = UIAlertController(title: "Permissão de localização", message: "Necessário a permissão de localização para usar o aplicativo", preferredStyle: .alert)
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            let acaoConfig = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfig) in
                
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            alerta.addAction(acaoCancelar)
            alerta.addAction(acaoConfig)
            
            present(alerta, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //centraliza
        self.centralizarNaLocalizacao()
        //para de atualizar localizacao
        gerenciadorLocalizacao.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: METODOS
    
    func configuraGerenciadorLocalizacao() {
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }

    //Centraliza o mapa na localização do usuario
    func centralizarNaLocalizacao() {
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate{
            let regiao = MKCoordinateRegionMakeWithDistance(coordenadas, 300, 300)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
}
