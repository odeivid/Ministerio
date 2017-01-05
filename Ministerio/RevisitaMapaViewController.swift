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
    
    let segueRevisitaNome = "verRevisita"
    var gerenciadorLocalizacao = CLLocationManager()
    var revisitas: [Revisita] = []
    var revisitaAnotacaoSelecionada: MKAnnotation!
    
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

    override func viewWillAppear(_ animated: Bool) {
        
        if (self.revisitaAnotacaoSelecionada != nil){
            
            self.carregarRevisitas()
            
            self.mapa.removeAnnotation(self.revisitaAnotacaoSelecionada)
            
            let revisita = (revisitaAnotacaoSelecionada as! RevisitaAnotacao).revisita
            let anotacao = RevisitaAnotacao(revisita: revisita)
            
            self.mapa.addAnnotation(anotacao)
            
            self.mapa.selectAnnotation(anotacao, animated: true)
            
       //     MapaGerenciador().centralizarNaLocalizacao(localizacao: self.revisitaAnotacaoSelecionada.coordinate, mapa: self.mapa)
            
            //self.revisitaAnotacaoSelecionada = nil
            
        }else{
            //centralizar na localizacao do usuario
            MapaGerenciador().centralizarNaLocalizacao(gerenciadorLocalizacao: gerenciadorLocalizacao, mapa: self.mapa)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //verifica se app tem permissao de localizacao
        let alerta = MapaGerenciador().solicitarPermissaoLocalizacaoUsuario(manager: manager, status: status)
        if alerta != nil{
            present(alerta!, animated: true, completion: nil)
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
        
        let btn = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = btn
        
        //pin.isDraggable = true
        
        //if let logo = UIImage(named: "logo-apps-foundation-small.jpg") {
        //  pin.detailCalloutAccessoryView = UIImageView(image: logo)
        //}
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let revisitaAnotacao = view.annotation as! RevisitaAnotacao
            
            self.revisitaAnotacaoSelecionada = revisitaAnotacao
            
            performSegue(withIdentifier: self.segueRevisitaNome, sender: revisitaAnotacao.revisita)
        }
        
        /*
        let placeName = revisitaAnotacao
        let placeInfo = revisitaAnotacao
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == self.segueRevisitaNome) {
            let revisitaViewController = segue.destination as! RevisitaCadastroViewController
            
            revisitaViewController.revisita = sender as! Revisita
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        //faz o zoom nas anotacoes se a qtde de annotations é igual a qtde de revisitas + 1 (motivo +1: incluir UserLocation)
        if self.revisitas.count + 1 == self.mapa.annotations.count && self.revisitaAnotacaoSelecionada == nil{
            MapaGerenciador().zoomToFitMapAnnotations(aMapView: self.mapa)
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
        
        if esconderTipo{  //esconde mapa e mostra info
            self.btnInfo.isHidden = false
            
            self.viewMapType.fadeOut(0.2, delay: 0, completion: { (Bool) in
            })
            
            self.btnInfo.fadeIn(0.2, delay: 0, completion: { (Bool) in
            })
        }else{
            self.viewMapType.isHidden = false
            
            self.btnInfo.fadeOut(0.2, delay: 0, completion: { (Bool) in
            })
            
            self.viewMapType.fadeIn(0.2, delay: 0, completion: { (Bool) in
            })
        }
        
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
