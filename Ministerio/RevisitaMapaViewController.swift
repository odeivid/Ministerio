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
    @IBOutlet weak var btnTrackingMode: UIButton!
    @IBOutlet weak var viewMapType: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var sgmMapType: UISegmentedControl!
    @IBOutlet weak var swtTransito: UISwitch!
    
    
    var gerenciadorLocalizacao = CLLocationManager()
    var contadorUpdateLocation = 0
    var revisitas: [Revisita] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapaGerenciador = MapaGerenciador()
        
        //a propria classa vai cuidar desses objetos
        self.mapa.delegate = self

        self.carregarRevisitas()
        self.mostrarRevisitas()

        mapaGerenciador.configuraGerenciadorLocalizacao(mapaDelegate: self, gerenciadorLocalizacao: gerenciadorLocalizacao)
        
        swtTransito.isOn = mapaGerenciador.recuperarMostrarTransito(mapa: self.mapa)
        
        sgmMapType.selectedSegmentIndex = mapaGerenciador.recuperarTipoMapaSegmentedValue(segmented: nil)
        self.mudarTipoMapa(self.sgmMapType)
        
        //Colocar sombra em botao
        FuncoesGerais().sombraButton(botao: btnTrackingMode)
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //verifica se app tem permissao de localizacao
        let alerta = MapaGerenciador().solicitarPermissaoLocalizacaoUsuario(manager: manager, status: status)
        if alerta != nil{
            present(alerta!, animated: true, completion: nil)
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contadorUpdateLocation < 3{
            //centraliza
            MapaGerenciador().centralizarNaLocalizacao(gerenciadorLocalizacao: gerenciadorLocalizacao, mapa: self.mapa)
            //para de atualizar localizacao
            gerenciadorLocalizacao.stopUpdatingLocation()
            self.contadorUpdateLocation += 1
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //se for anotacao da localizacao do usuario, retorna nil para manter o icon padrao
        if annotation  is MKUserLocation{
            return nil
        }
        //reusa o pin
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        //se for estudo pinta de verde
        if (annotation as! RevisitaAnotacao).revisita.estudoSimNao {
            pin.pinTintColor = FuncoesGerais().corRevisita
        }
        pin.canShowCallout = true
        //pin.isDraggable = true
        
        //if let logo = UIImage(named: "logo-apps-foundation-small.jpg") {
        //  pin.detailCalloutAccessoryView = UIImageView(image: logo)
        //}
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        if self.contadorUpdateLocation == 3{
            MapaGerenciador().zoomToFitMapAnnotations(aMapView: self.mapa)
            self.contadorUpdateLocation += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.esconderTipoMapa(esconderTipo: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK: METODOS
    func carregarRevisitas() {
        revisitas = CoreDataRevisita().getRevisitas(ativoSimNao: true)
    }
    
    func mostrarRevisitas() {
        //adiciona a anotacao de cada revista buscada
        for revisita in self.revisitas{
            self.mapa.addAnnotation(RevisitaAnotacao(revisita: revisita))
        }
    }
    
    func esconderTipoMapa(esconderTipo: Bool) {
      //  sgmMapType.isHidden = esconderTipo
        btnInfo.isHidden = !esconderTipo
        viewMapType.isHidden = esconderTipo
    }
    
    //MARK: ACTIONS
    
    @IBAction func centralizarLocalizacaoUsuario(_ sender: Any) {
        
        //muda o trankingMode
        MapaGerenciador().mudarTrackingMode(mapa: self.mapa)
    }
    
    @IBAction func btnMostrarInfo(_ sender: Any) {

        self.esconderTipoMapa(esconderTipo: false)
    }
    @IBAction func mudarTipoMapa(_ sender: Any) {
        switch self.sgmMapType.selectedSegmentIndex {
        case 0:
            self.mapa.mapType = .standard
        case 1:
            self.mapa.mapType = .hybrid
        default:
            self.mapa.mapType = .satellite
        }
        
        MapaGerenciador().salvarTipoMapaSegmentedValue(segmentedIndex: self.sgmMapType.selectedSegmentIndex)
        
        self.esconderTipoMapa(esconderTipo: true)
    }
    
    @IBAction func mostrarTransito(_ sender: Any) {
        MapaGerenciador().salvarMostrarTransito(mostrar: self.swtTransito.isOn, mapa: self.mapa)
    }
    
    
}
