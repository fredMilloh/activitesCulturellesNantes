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
}

enum EventsError: Error {
    case missingData
    case errorResponse
    case cannotProcessData
}
