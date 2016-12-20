//
//  CoreDataRevisita.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 20/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import CoreData

class CoreDataRevisita {
    
    //recuperar contexto
    func getContext() -> NSManagedObjectContext{
        return ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    }
    
    func getRevisitas(ativoSimNao: Bool) -> [Revisita] {
        
        do{
            let requisicao = Revisita.fetchRequest() as NSFetchRequest<Revisita>
            requisicao.predicate = NSPredicate(format: "ativoSimNao = %@", ativoSimNao as CVarArg)
            return try self.getContext().fetch(requisicao) as [Revisita]
        }catch{
            return []
        }
    }
    
    func salvarRevisita(revisita: Revisita) {
        do{
            let contexto = self.getContext()
            
            contexto.insert(revisita as NSManagedObject)
            
            try contexto.save()
            
        }catch{
            
        }
    }
    
}
