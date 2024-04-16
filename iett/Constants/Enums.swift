//
//  Enums.swift
//  iett
//
//  Created by Türker Kızılcık on 2.04.2024.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
}

enum IETTUrl : String {
    case hatDurakGuzergah = "https://api.ibb.gov.tr/iett/UlasimAnaVeri/HatDurakGuzergah.asmx?wsdl"
    case duyuru = "https://api.ibb.gov.tr/iett/UlasimDinamikVeri/Duyurular.asmx?wsdl"
    case filo = "https://api.ibb.gov.tr/iett/FiloDurum/SeferGerceklesme.asmx?wsdl"
    case crm = "https://api.ibb.gov.tr/iett/ibb/ibb.asmx?wsdl"
    case planlananSefer = "https://api.ibb.gov.tr/iett/UlasimAnaVeri/PlanlananSeferSaati.asmx?wsdl"
    case aracOzellikleri = "https://api.ibb.gov.tr/iett/AracAnaVeri/AracOzellik.asmx?wsdl"
    case ibb360 = "https://api.ibb.gov.tr/iett/ibb/ibb360.asmx?wsdl"
}
