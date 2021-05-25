//
//  AppDelegate.swift
//  ContactosCoreData
//
//  Created by Jorge Luis Baltazar Perez on 18/05/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         El contenedor persistente de la aplicación. Esta implementación
         crea y devuelve un contenedor, habiendo cargado la tienda para el
         aplicación a él. Esta propiedad es opcional ya que existen
         condiciones de error que podrían provocar que falle la creación de la tienda.
         */
        let container = NSPersistentContainer(name: "Contacto")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Reemplace esta implementación con código para manejar el error de manera apropiada.
                // fatalError () hace que la aplicación genere un registro de fallos y finalice. No debe utilizar esta función en una aplicación de envío, aunque puede resultar útil durante el desarrollo.
                
                /*
                 Las razones típicas de un error aquí incluyen:
                 * El directorio principal no existe, no se puede crear o no permite la escritura.
                 * No se puede acceder al almacén persistente debido a permisos o protección de datos cuando el dispositivo está bloqueado.
                 * El dispositivo no tiene espacio.
                 * La tienda no se pudo migrar a la versión del modelo actual.
                 Verifique el mensaje de error para determinar cuál fue el problema real.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Reemplace esta implementación con código para manejar el error de manera apropiada.
                // fatalError () hace que la aplicación genere un registro de fallos y finalice. No debe utilizar esta función en una aplicación de envío, aunque puede resultar útil durante el desarrollo.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

