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
        self.mapa.delegate = self
        MapaGerenciador().configuraGerenciadorLocalizacao(mapaDelegate: self, gerenciadorLocalizacao: gerenciadorLocalizacao)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: METODOS

    
}
