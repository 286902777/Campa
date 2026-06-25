import Foundation

enum PersonalInfoGender: String {
    case male
    case female
}

final class PersonalInfoViewModel {
    let nameTitle = NSLocalizedString("Name:", comment: "Personal info name label")
    let birthdayTitle = NSLocalizedString("Birthday:", comment: "Personal info birthday label")
    let locationTitle = NSLocalizedString("Location:", comment: "Personal info location label")
    let genderTitle = NSLocalizedString("Gender:", comment: "Personal info gender label")
    let namePlaceholder = NSLocalizedString("Enter username", comment: "Personal info name placeholder")
    let birthdayPlaceholder = NSLocalizedString("2003-01-01", comment: "Personal info birthday placeholder")
    let locationPlaceholder = NSLocalizedString("La", comment: "Personal info location placeholder")
    let maleTitle = NSLocalizedString("Male", comment: "Male gender option")
    let femaleTitle = NSLocalizedString("Female", comment: "Female gender option")
    let saveTitle = NSLocalizedString("Save", comment: "Save personal info")
    let defaultGender: PersonalInfoGender = .male
    let requiredInfoMessage = NSLocalizedString("Please complete all information", comment: "Personal info required fields toast")
    let missingRegistrationMessage = NSLocalizedString("Missing sign up information", comment: "Missing registration draft toast")
    let saveFailedMessage = NSLocalizedString("Save failed", comment: "Personal info save failure toast")

    let countryNames: [String]

    init(locale: Locale = .current) {
        countryNames = Locale.isoRegionCodes
            .compactMap { locale.localizedString(forRegionCode: $0) }
            .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }
}
