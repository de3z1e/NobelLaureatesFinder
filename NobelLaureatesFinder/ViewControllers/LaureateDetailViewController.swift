//
//  LaureateDetailViewController.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/29/21.
//

import UIKit

class LaureateDetailViewController: UIViewController {

    var laureate: Laureate?
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10
            containerView.clipsToBounds = true
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            blurView.frame = containerView.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.insertSubview(blurView, at: 0)
        }
    }
    
    @IBOutlet weak var awardDescriptionContainer: UIView! {
        didSet {
            awardDescriptionContainer.layer.cornerRadius = 10
            awardDescriptionContainer.clipsToBounds = true
        }
    }
    @IBOutlet weak var laureateName: UILabel!
    @IBOutlet weak var institutionName: UILabel!
    @IBOutlet weak var dateAndLocation: UILabel!
    @IBOutlet weak var awardDescription: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var born: UILabel!
    @IBOutlet weak var died: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        laureateName.text = "\(laureate?.firstName ?? "") \(laureate?.surname ?? "")"
        institutionName.text = laureate?.name
        dateAndLocation.text = "\(laureate?.year.description ?? "") - \(laureate?.city ?? ""), \(laureate?.country ?? "")"
        awardDescription.text = formattedAwardDescription(category: laureate?.category, motivation: laureate?.motivation, gender: laureate?.gender)
        gender.text = laureate?.gender?.capitalized
        born.text = formattedDateAndCityCountry(date: laureate?.born, city: laureate?.bornCity, country: laureate?.bornCountry)
        died.text = formattedDateAndCityCountry(date: laureate?.died, city: laureate?.diedCity, country: laureate?.diedCountry)
    }
    
    private func formattedAwardDescription(category: String?, motivation: String?, gender: String?) -> String? {
        guard let prizeCategory = category,
              let prizeDescription = motivation,
              let gender = gender?.lowercased() else {
            return nil
        }
        let formattedPrizeDescription = prizeDescription
            .trimmingCharacters(in: .init(charactersIn: "\""))
            .replacingOccurrences(of: "their", with: gender == "male" ? "his" : "her")
        return "Awarded the Nobel Prize in \(prizeCategory) \(formattedPrizeDescription)."
    }

    private func formattedDate(date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
    
    private func formattedCityCountry(city: String?, country: String?) -> String? {
        guard let city = city, let country = country else { return nil }
        return "\(city), \(country)"
    }
    
    private func formattedDateAndCityCountry(date: Date?, city: String?, country: String?) -> String {
        if let formattedDate = formattedDate(date: date),
           let formattedCityCountry = formattedCityCountry(city: city, country: country) {
            return "\(formattedDate) in \(formattedCityCountry)"
        } else if let formattedDate = formattedDate(date: date) {
            return formattedDate
        } else if let formattedCityCountry = formattedCityCountry(city: city, country: country) {
            return formattedCityCountry
        } else {
            return "N/A"
        }
    }
}
