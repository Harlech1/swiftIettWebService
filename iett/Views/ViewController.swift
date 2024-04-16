//
//  ViewController.swift
//  iett
//
//  Created by Türker Kızılcık on 29.03.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "doorNumber".localized()
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let stationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Durak ismi giriniz: "
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let callAPIButton: UIButton = {
        let button = UIButton()
        button.setTitle("callAPI".localized(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    let showAllStationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tüm Duraklar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    let showOneStationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Bir Durak", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    let responselabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.numberOfLines = 10
        return label
    }()

    let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let horizontalStackView1: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var soapMessage = ""
    var soapURL = ""

    let locationManager = CLLocationManager()

    var busCoordinates = CLLocationCoordinate2D()
    var stationCoordinates = CLLocationCoordinate2D()

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()

        callAPIButton.addTarget(self, action: #selector(callAPIButtonTapped), for: .touchUpInside)
        showAllStationsButton.addTarget(self, action: #selector(showAllStationsButtonTapped), for: .touchUpInside)
        showOneStationButton.addTarget(self, action: #selector(showOneStationButtonTapped), for: .touchUpInside)

        setUpConstraints()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func findAnnotationWithTitle(_ title: String, in mapView: MKMapView) -> MKAnnotation? {
        for annotation in mapView.annotations {
            if annotation.title == title {
                return annotation
            }
        }
        return nil
    }


    @objc func showOneStationButtonTapped() {
        let annotation = findAnnotationWithTitle(stationTextField.text!, in: mapView)
        let coordinate = (annotation?.coordinate)!
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)

        view.endEditing(true)
    }

    @objc func showAllStationsButtonTapped() {
        let request = SOAPRequest(
            soapURL: IETTUrl.hatDurakGuzergah.rawValue,
            soapMessage: """
            <tem:GetDurak_json>
                <tem:DurakKodu></tem:DurakKodu>
            </tem:GetDurak_json>
            """.buildSOAPEnvelope(),
            HTTPMethod: HTTPMethod.post.rawValue,
            HTTPHeader: ["text/xml" : "Content-Type"])
        guard let soapRequest = NetworkManager.shared.createSOAPRequest(soapRequest: request) else { return }
        NetworkManager.shared.sendSOAPRequest(request: soapRequest) { result in
            switch result {
            case .success(let responseData):
                guard let jsonData = StringManager.shared.extractJSONDataFromResponse(data: responseData) else {
                    print("JSON data couldn't be extracted.")
                    return
                }
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
                    DispatchQueue.main.async {
                        var coordinatesArray: [(latitude: Double, longitude: Double)] = []
                        jsonArray?.forEach { jsonObject in
                            guard let coordinateString = jsonObject["KOORDINAT"] as? String else { return }
                            guard let coordinate = self.extractCoordinates(fromString: coordinateString) else { return }

                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)

                            if let stopName = jsonObject["SDURAKADI"] as? String {
                                annotation.title = stopName
                            }

                            self.mapView.addAnnotation(annotation)
                        }
                    }
                } catch {
                    print("error in try-catch")
                }
            case .failure(let error):
                print("Error is: \(error)")
            }
        }
    }

    @objc func callAPIButtonTapped() {
        let request = SOAPRequest(
            soapURL: IETTUrl.filo.rawValue,
            soapMessage: "<tem:GetFiloAracKonum_json/>".buildSOAPEnvelope(),
            HTTPMethod: HTTPMethod.post.rawValue,
            HTTPHeader: ["text/xml" : "Content-Type"])

        guard let soapRequest = NetworkManager.shared.createSOAPRequest(soapRequest: request) else { return }
        NetworkManager.shared.sendSOAPRequest(request: soapRequest) { result in
            switch result {
            case .success(let responseData):
                guard let jsonData = StringManager.shared.extractJSONDataFromResponse(data: responseData) else {
                    print("JSON data couldn't be extracted.")
                    return
                }
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
                    DispatchQueue.main.async {
                        guard
                            let obj = jsonArray?.first(where: {$0["KapiNo"] as? String == self.urlTextField.text}),
                            let latitude = obj["Enlem"] as? String,
                            let longitude = obj["Boylam"] as? String
                        else {
                            print("Object with name: \(self.urlTextField.text ?? "") doesn't exist")
                            self.showAlert(self.urlTextField.text ?? "Bu")
                            return
                        }

                        self.busCoordinates = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                        self.stationCoordinates = CLLocationCoordinate2D(latitude: 40.9150550436188, longitude: 29.1496060429753)

                        let info = """
                        Enlem:   \(obj["Enlem"] ?? "-")
                        Boylam:   \(obj["Boylam"] ?? "-")
                        Anlık Hız:   \(obj["Hiz"] ?? "-")
                        Son Güncelleme:   \(obj["Saat"] ?? "-")
                        Kapı Numarası: \(obj["KapiNo"] ?? "-")
                        Plaka: \(obj["Plaka"] ?? "-")
                        """

                        self.responselabel.text = info
                        print(info)

                        MapManager.shared.updateMapView(busCoordinates: self.busCoordinates, stationCoordinates: self.stationCoordinates, mapView: self.mapView)

                        self.view.endEditing(true)
                    }
                } catch {
                    print("JSON serialization failed.")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func extractCoordinates(fromString string: String) -> (latitude: Double, longitude: Double)? {
        var cleanedString = string.replacingOccurrences(of: "POINT (", with: "")
        cleanedString = cleanedString.replacingOccurrences(of: ")", with: "")

        let components = cleanedString.components(separatedBy: " ")

        if let latitude = Double(components[1]), let longitude = Double(components[0]) {
            return (latitude, longitude)
        } else {
            return nil
        }
    }

    func showAlert(_ idk: String) {
        let alertController = UIAlertController(title: "Hat Kodu Hatalı", message: "\(idk) hat kodunda bir otobüs yok.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            print("OK button tapped")
            self.urlTextField.text = ""
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    @objc func workBackground() {
        /*callAPI {
         let distanceKilometers = self.calculateDistanceBetweenCoordinates(coord1: self.busCoordinates, coord2: self.stationCoordinates)
         self.sendNotification(fark: distanceKilometers)
         }*/
    }

    @objc func sendNotification(fark: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Otobüsünüz geliyor"
        content.body = "Otobüsünüzün varmasına \(fark)km"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim oluşturulamadı: \(error.localizedDescription)")
            } else {
                print("Bildirim başarıyla oluşturuldu")
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10,
                                     target: self,
                                     selector: #selector(workBackground),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.current.add(timer!, forMode: .default)
    }
}

