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
    
    func criarAnotacao(mapa: MKMapView, titulo: String?, latitude:Double, longitude: Double) {
        
        let anotacao = MKPointAnnotation()
        anotacao.coordinate.latitude = latitude
        anotacao.coordinate.longitude = longitude
        
        anotacao.title = titulo
        mapa.addAnnotation(anotacao)
    }
    
    //Regular o zoom no mapa para caber as anotacoes
    func zoomToFitMapAnnotations(aMapView: MKMapView) {
        guard aMapView.annotations.count > 1 else {
            return
        }
        var topLeftCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        topLeftCoord.latitude = -90
        topLeftCoord.longitude = 180
        var bottomRightCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        bottomRightCoord.latitude = 90
        bottomRightCoord.longitude = -180
        for annotation: MKAnnotation in aMapView.annotations{
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 2.4
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 2.4
        region = aMapView.regionThatFits(region)
        aMapView.setRegion(region, animated: true)
    }
    
    
    func mudarTrackingMode(mapa: MKMapView) {
        switch mapa.userTrackingMode {
        case .none:
            mapa.userTrackingMode = .follow
        case .follow:
            mapa.userTrackingMode = .followWithHeading
        default:
            mapa.userTrackingMode = .none
        }
    }
}
