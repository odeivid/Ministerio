//
//  RevisitaAnotacao.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 21/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import MapKit

class RevisitaAnotacao: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var revisita: Revisita
    
    init(revisita: Revisita) {

        self.coordinate = CLLocationCoordinate2DMake(revisita.latitude, revisita.longitude)
        self.title = revisita.nome
        self.subtitle = revisita.endereco
        self.revisita = revisita
    }
}
