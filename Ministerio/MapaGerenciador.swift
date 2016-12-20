//
//  MapaGerenciador.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 20/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import MapKit

class MapaGerenciador {
    
    func configuraGerenciadorLocalizacao(mapaDelegate: CLLocationManagerDelegate, gerenciadorLocalizacao: CLLocationManager) {
        gerenciadorLocalizacao.delegate = mapaDelegate
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    //Centraliza o mapa na localização do usuario
    func centralizarNaLocalizacao(gerenciadorLocalizacao: CLLocationManager, mapa: MKMapView) {
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate{
            let regiao = MKCoordinateRegionMakeWithDistance(coordenadas, 300, 300)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    func solicitarPermissaoLocalizacaoUsuario(manager: CLLocationManager, status: CLAuthorizationStatus) -> UIAlertController! {
        
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
            
            return alerta
        }
        
        return nil
    }
}
