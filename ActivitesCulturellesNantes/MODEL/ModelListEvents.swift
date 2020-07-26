//
//  ModelListEvents.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import Foundation

struct ModelListEvents: Decodable {
    var records: [records]
}

struct records: Decodable {
    var fields: (fields)
}

struct fields: Decodable {
    var nom: String
    var media_1: String?
    var gratuit: String
    var complet: String?
    var id_manif: String
    var heure_debut: String?
    var heure_fin: String?
    var lieu: String
    var adresse: String
    var ville: String
    var description: String
    var info_suppl: String?
    var precisions_tarifs: String?
 
}

enum EventsError: Error {
    case missingData
    case errorResponse
    case cannotProcessData
}
