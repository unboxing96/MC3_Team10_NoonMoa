import Foundation
import SwiftUI
import WeatherKit

class EnvironmentViewModel: ObservableObject {
    @Published var weather: Weather?

    @Published var environment: EnvironmentRecord = EnvironmentRecord(rawWeather: "clear", rawTime: Date(), rawSunriseTime: Date(), rawSunsetTime: Date())
    @Published var environmentViewData: EnvironmentRecordViewData = EnvironmentRecordViewData(weather: "clear", isWind: false, isThunder: false, time: "morning", lottieImageName: Lottie.clearMorning, colorOfSky: .sky.clearMorning, colorOfGround: .ground.clearMorning, broadcastAttendanceIncompleteTitle: String.broadcast.attendanceIncompleteTitle.clearMorning, broadcastAttendanceIncompleteBody: String.broadcast.attendanceIncompleteBody.clearMorning, broadcastAttendanceCompletedTitle: String.broadcast.attendanceCompletedTitle.clearMorning, broadcastAttendanceCompletedBody: String.broadcast.attendanceCompletedBody.clearMorning, broadcastAnnounce: String.broadcast.announce[0], stampLargeSkyImage: Image.assets.stampLarge.clearMorning, stampSmallSkyImage: Image.assets.stampSmall.clearMorning, stampBorderColor: Color.stampBorder.clearMorning)
    
    var recordedEnvironment: EnvironmentRecord = EnvironmentRecord(rawWeather: "clear", rawTime: Date(), rawSunriseTime: Date(), rawSunsetTime: Date())
    var recordedEnvironmentViewData: EnvironmentRecordViewData = EnvironmentRecordViewData(weather: "clear", isWind: false, isThunder: false, time: "morning", lottieImageName: Lottie.clearMorning, colorOfSky: .sky.clearMorning, colorOfGround: .ground.clearMorning, broadcastAttendanceIncompleteTitle: String.broadcast.attendanceIncompleteTitle.clearMorning, broadcastAttendanceIncompleteBody: String.broadcast.attendanceIncompleteBody.clearMorning, broadcastAttendanceCompletedTitle: String.broadcast.attendanceCompletedTitle.clearMorning, broadcastAttendanceCompletedBody: String.broadcast.attendanceCompletedBody.clearMorning, broadcastAnnounce: String.broadcast.announce[0], stampLargeSkyImage: Image.assets.stampLarge.clearMorning, stampSmallSkyImage: Image.assets.stampSmall.clearMorning, stampBorderColor: Color.stampBorder.clearMorning)

    
    @MainActor func getWeather(latitude: Double, longitude: Double) async {
        print("getWeather | latitude: \(latitude), longtitude: \(longitude)")
        Task(priority: .userInitiated) {
            do {
                weather = try await Task(priority: .userInitiated) {
                    return try await WeatherService.shared.weather(for:.init(latitude: latitude, longitude: longitude))
                }.value
                print(latitude)
                print(longitude)
                let condition = weather?.currentWeather.condition.rawValue ?? "clear"
                let date = Date()
                let sunrise = weather?.dailyForecast[0].sun.sunrise ?? Date()
                let sunset = weather?.dailyForecast[0].sun.sunset ?? Date()
                self.environment = EnvironmentRecord(rawWeather: condition, rawTime: date, rawSunriseTime: sunrise, rawSunsetTime: sunset)
                convertRawDataToEnvironmentViewData(isInputAttndanceRecord: false, environmentModel: self.environment)
                print("environment | \(environment)")
                print("environmentViewData | \(environmentViewData)")
            } catch {
                print("Weather error: \(error)")
                fatalError("\(error)")
            }
        }
    }
    
    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }
    
    var temp: String {
        let temp = weather?.currentWeather.temperature
        let convertedTemp = temp?.converted(to: .celsius).description
        return convertedTemp ?? "Connecting to WeatherKit"
    }
    
    // isThisForCalendarView가 false일 때는 Input: WeatherKit으로 부터 받은 값, Output: 뷰에서 사용하는 environmentRecordViewData에 할당.
    // isThisForCalendarView가 true일 때는 Input: AttendanceRecord로 부터 받은 값, Output: Calendar뷰에서 사용하는 recordedEnvironmentViewData에 할당.
    func convertRawDataToEnvironmentViewData(isInputAttndanceRecord: Bool, environmentModel: EnvironmentRecord) {
        
        let weather = environmentModel.rawWeather
        let time = environmentModel.rawTime
        let sunrise = environmentModel.rawSunriseTime
        let sunset = environmentModel.rawSunsetTime
        
        let environmentWeather: String
        switch weather {
        case "clear", "hot", "mostlyClear", "mostlyCloudy", "partlyCloudy" : environmentWeather = "clear"
        case "blowingDust", "cloudy", "foggy", "haze", "hurricane", "smoky" : environmentWeather = "cloudy"
        case "rain", "heavyRain", "freezingRain", "sunShowers", "drizzle", "freezingDrizzle", "hail" : environmentWeather = "rainy"
        case "blizzard", "snow", "sunFlurries", "heavySnow", "blowingSnow", "flurries", "sleet", "frigid", "wintryMix": environmentWeather = "snowy"
        default: environmentWeather = "clear"
        }
        
        let environmentIsWind: Bool
        switch weather {
        case "blowingDust", "hurricane", "hail", "blizzard", "breezy", "windy", "tropicalStrom": environmentIsWind = true
        default: environmentIsWind = false
        }
        
        let environmentIsThunder: Bool
        switch weather {
        case "thunderstorms", "strongStorms", "isolatedThunderstorms", "scatteredThunderstorms": environmentIsThunder = true
        default: environmentIsThunder = false
        }
        
        let environmentTime: String
        let t = getHourFromDate(time: time)
        let sunriseHour = getHourFromDate(time: sunrise)
        let sunsetHour = getHourFromDate(time: sunset)
        switch t {
        case let t where t == sunriseHour: environmentTime = "sunrise"
        case let t where t == sunsetHour: environmentTime = "sunset"
        case let t where (t >= 22) || (t >= 0 && t < 6): environmentTime = "night"
        case let t where t >= 6 && t < 12: environmentTime = "morning"
        case let t where t >= 12 && t < 19: environmentTime = "afternoon"
        case let t where t >= 19 && t < 22: environmentTime = "evening"
        default: environmentTime = "sunrise"
        }
        
        var viewData = [String: Any]()
        switch environmentWeather {
        case "clear":
            switch environmentTime {
            case "sunrise":
                viewData = ["lottieImageName": Lottie.clearSunrise,
                            "colorOfSky": LinearGradient.sky.clearSunrise,
                            "colorOfGround": LinearGradient.ground.clearSunrise,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.clearSunrise,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.clearSunrise,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.clearSunrise,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.clearSunrise,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.clearSunrise,
                            "stampSmallSkyImage": Image.assets.stampSmall.clearSunrise,
                            "stampBorderColor": Color.stampBorder.clearSunrise]
           
            case "morning":
                viewData = ["lottieImageName": Lottie.clearMorning,
                            "colorOfSky": LinearGradient.sky.clearMorning,
                            "colorOfGround": LinearGradient.ground.clearMorning,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.clearMorning,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.clearMorning,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.clearMorning,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.clearMorning,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.clearMorning,
                            "stampSmallSkyImage": Image.assets.stampSmall.clearMorning,
                            "stampBorderColor": Color.stampBorder.clearMorning]
                
            case "afternoon":
                viewData = ["lottieImageName": Lottie.clearAfternoon,
                            "colorOfSky": LinearGradient.sky.clearAfternoon,
                            "colorOfGround": LinearGradient.ground.clearAfternoon,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.clearAfternoon,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.clearAfternoon,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.clearAfternoon,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.clearAfternoon,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.clearAfternoon,
                            "stampSmallSkyImage": Image.assets.stampSmall.clearAfternoon,
                            "stampBorderColor": Color.stampBorder.clearAfternoon]
                
            case "sunset":
                viewData = ["lottieImageName": Lottie.clearSunset,
                            "colorOfSky": LinearGradient.sky.clearSunset,
                            "colorOfGround": LinearGradient.ground.clearSunset,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.clearSunset,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.clearSunset,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.clearSunset,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.clearSunset,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.clearSunset,
                            "stampSmallSkyImage": Image.assets.stampSmall.clearSunset,
                            "stampBorderColor": Color.stampBorder.clearSunset]
                
            case "evening":
                viewData = ["lottieImageName": Lottie.clearEvening,
                            "colorOfSky": LinearGradient.sky.clearEvening,
                            "colorOfGround": LinearGradient.ground.clearEvening,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.clearEvening,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.clearEvening,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.clearEvening,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.clearEvening,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.clearEvening,
                            "stampSmallSkyImage": Image.assets.stampSmall.clearEvening,
                            "stampBorderColor": Color.stampBorder.clearEvening]
                
            case "night":
                viewData = ["lottieImageName": Lottie.clearNight,
                            "colorOfSky": LinearGradient.sky.clearNight,
                            "colorOfGround": LinearGradient.ground.clearNight,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.clearNight,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.clearNight,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.clearNight,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.clearNight,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.clearNight,
                            "stampSmallSkyImage": Image.assets.stampSmall.clearNight,
                            "stampBorderColor": Color.stampBorder.clearNight]
            default: viewData = [:]
            }
            
        case "cloudy":
            switch environmentTime {
            case "sunrise":
                viewData = ["lottieImageName": Lottie.cloudySunrise,
                            "colorOfSky": LinearGradient.sky.cloudySunrise,
                            "colorOfGround": LinearGradient.ground.cloudySunrise,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.cloudySunrise,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.cloudySunrise,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.cloudySunrise,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.cloudySunrise,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.cloudySunrise,
                            "stampSmallSkyImage": Image.assets.stampSmall.cloudySunrise,
                            "stampBorderColor": Color.stampBorder.cloudySunrise]
                
            case "morning":
                viewData = ["lottieImageName": Lottie.cloudyMorning,
                            "colorOfSky": LinearGradient.sky.cloudyMorning,
                            "colorOfGround": LinearGradient.ground.cloudyMorning,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.cloudyMorning,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.cloudyMorning,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.cloudyMorning,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.cloudyMorning,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.cloudyMorning,
                            "stampSmallSkyImage": Image.assets.stampSmall.cloudyMorning,
                            "stampBorderColor": Color.stampBorder.cloudyMorning]
                
            case "afternoon":
                viewData = ["lottieImageName": Lottie.cloudyAfternoon,
                            "colorOfSky": LinearGradient.sky.cloudyAfternoon,
                            "colorOfGround": LinearGradient.ground.cloudyAfternoon,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.cloudyAfternoon,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.cloudyAfternoon,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.cloudyAfternoon,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.cloudyAfternoon,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.cloudyAfternoon,
                            "stampSmallSkyImage": Image.assets.stampSmall.cloudyAfternoon,
                            "stampBorderColor": Color.stampBorder.cloudyAfternoon]
                
            case "sunset":
                viewData = ["lottieImageName": Lottie.cloudySunset,
                            "colorOfSky": LinearGradient.sky.cloudySunset,
                            "colorOfGround": LinearGradient.ground.cloudySunset,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.cloudySunset,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.cloudySunset,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.cloudySunset,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.cloudySunset,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.cloudySunset,
                            "stampSmallSkyImage": Image.assets.stampSmall.cloudySunset,
                            "stampBorderColor": Color.stampBorder.cloudySunset]
                
            case "evening":
                viewData = ["lottieImageName": Lottie.cloudyEvening,
                            "colorOfSky": LinearGradient.sky.cloudyEvening,
                            "colorOfGround": LinearGradient.ground.cloudyEvening,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.cloudyEvening,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.cloudyEvening,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.cloudyEvening,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.cloudyEvening,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.cloudyEvening,
                            "stampSmallSkyImage": Image.assets.stampSmall.cloudyEvening,
                            "stampBorderColor": Color.stampBorder.cloudyEvening]
                
            case "night":
                viewData = ["lottieImageName": Lottie.cloudyNight,
                            "colorOfSky": LinearGradient.sky.cloudyNight,
                            "colorOfGround": LinearGradient.ground.cloudyNight,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.cloudyNight,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.cloudyNight,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.cloudyNight,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.cloudyNight,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.cloudyNight,
                            "stampSmallSkyImage": Image.assets.stampSmall.cloudyNight,
                            "stampBorderColor": Color.stampBorder.cloudyNight]
            default: viewData = [:]
            }
            
        case "rainy":
            switch environmentTime {
            case "sunrise":
                viewData = ["lottieImageName": Lottie.rainySunrise,
                            "colorOfSky": LinearGradient.sky.rainySunrise,
                            "colorOfGround": LinearGradient.ground.rainySunrise,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.rainySunrise,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.rainySunrise,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.rainySunrise,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.rainySunrise,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.rainySunrise,
                            "stampSmallSkyImage": Image.assets.stampSmall.rainySunrise,
                            "stampBorderColor": Color.stampBorder.rainySunrise]
                
            case "morning":
                viewData = ["lottieImageName": Lottie.rainyMorning,
                            "colorOfSky": LinearGradient.sky.rainyMorning,
                            "colorOfGround": LinearGradient.ground.rainyMorning,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.rainyMorning,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.rainyMorning,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.rainyMorning,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.rainyMorning,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.rainyMorning,
                            "stampSmallSkyImage": Image.assets.stampSmall.rainyMorning,
                            "stampBorderColor": Color.stampBorder.rainyMorning]
                
            case "afternoon":
                viewData = ["lottieImageName": Lottie.rainyAfternoon,
                            "colorOfSky": LinearGradient.sky.rainyAfternoon,
                            "colorOfGround": LinearGradient.ground.rainyAfternoon,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.rainyAfternoon,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.rainyAfternoon,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.rainyAfternoon,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.rainyAfternoon,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.rainyAfternoon,
                            "stampSmallSkyImage": Image.assets.stampSmall.rainyAfternoon,
                            "stampBorderColor": Color.stampBorder.rainyAfternoon]
                
            case "sunset":
                viewData = ["lottieImageName": Lottie.rainySunset,
                            "colorOfSky": LinearGradient.sky.rainySunset,
                            "colorOfGround": LinearGradient.ground.rainySunset,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.rainySunset,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.rainySunset,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.rainySunset,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.rainySunset,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.rainySunset,
                            "stampSmallSkyImage": Image.assets.stampSmall.rainySunset,
                            "stampBorderColor": Color.stampBorder.rainySunset]
                
            case "evening":
                viewData = ["lottieImageName": Lottie.rainyEvening,
                            "colorOfSky": LinearGradient.sky.rainyEvening,
                            "colorOfGround": LinearGradient.ground.rainyEvening,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.rainyEvening,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.rainyEvening,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.rainyEvening,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.rainyEvening,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.rainyEvening,
                            "stampSmallSkyImage": Image.assets.stampSmall.rainyEvening,
                            "stampBorderColor": Color.stampBorder.rainyEvening]
                
            case "night":
                viewData = ["lottieImageName": Lottie.rainyNight,
                            "colorOfSky": LinearGradient.sky.rainyNight,
                            "colorOfGround": LinearGradient.ground.rainyNight,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.rainyNight,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.rainyNight,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.rainyNight,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.rainyNight,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.rainyNight,
                            "stampSmallSkyImage": Image.assets.stampSmall.rainyNight,
                            "stampBorderColor": Color.stampBorder.rainyNight]
            default: viewData = [:]
            }
            
        case "snowy":
            switch environmentTime {
            case "sunrise":
                viewData = ["lottieImageName": Lottie.snowySunrise,
                            "colorOfSky": LinearGradient.sky.snowySunrise,
                            "colorOfGround": LinearGradient.ground.snowySunrise,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.snowySunrise,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.snowySunrise,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.snowySunrise,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.snowySunrise,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.snowySunrise,
                            "stampSmallSkyImage": Image.assets.stampSmall.snowySunrise,
                            "stampBorderColor": Color.stampBorder.snowySunrise]
                
            case "morning":
                viewData = ["lottieImageName": Lottie.snowyMorning,
                            "colorOfSky": LinearGradient.sky.snowyMorning,
                            "colorOfGround": LinearGradient.ground.snowyMorning,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.snowyMorning,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.snowyMorning,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.snowyMorning,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.snowyMorning,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.snowyMorning,
                            "stampSmallSkyImage": Image.assets.stampSmall.snowyMorning,
                            "stampBorderColor": Color.stampBorder.snowyMorning]
                
            case "afternoon":
                viewData = ["lottieImageName": Lottie.snowyAfternoon,
                            "colorOfSky": LinearGradient.sky.snowyAfternoon,
                            "colorOfGround": LinearGradient.ground.snowyAfternoon,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.snowyAfternoon,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.snowyAfternoon,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.snowyAfternoon,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.snowyAfternoon,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.snowyAfternoon,
                            "stampSmallSkyImage": Image.assets.stampSmall.snowyAfternoon,
                            "stampBorderColor": Color.stampBorder.snowyAfternoon]
                
            case "sunset":
                viewData = ["lottieImageName": Lottie.snowySunset,
                            "colorOfSky": LinearGradient.sky.snowySunset,
                            "colorOfGround": LinearGradient.ground.snowySunset,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.snowySunset,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.snowySunset,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.snowySunset,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.snowySunset,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.snowySunset,
                            "stampSmallSkyImage": Image.assets.stampSmall.snowySunset,
                            "stampBorderColor": Color.stampBorder.snowySunset]
                
            case "evening":
                viewData = ["lottieImageName": Lottie.snowyEvening,
                            "colorOfSky": LinearGradient.sky.snowyEvening,
                            "colorOfGround": LinearGradient.ground.snowyEvening,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.snowyEvening,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.snowyEvening,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.snowyEvening,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.snowyEvening,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.snowyEvening,
                            "stampSmallSkyImage": Image.assets.stampSmall.snowyEvening,
                            "stampBorderColor": Color.stampBorder.snowyEvening]
                
            case "night":
                viewData = ["lottieImageName": Lottie.snowyNight,
                            "colorOfSky": LinearGradient.sky.snowyNight,
                            "colorOfGround": LinearGradient.ground.snowyNight,
                            "currentBroadcastAttendanceIncompleteTitle": String.broadcast.attendanceIncompleteTitle.snowyNight,
                            "currentBroadcastAttendanceIncompleteBody": String.broadcast.attendanceIncompleteBody.snowyNight,
                            "currentBroadcastAttendanceCompletedTitle": String.broadcast.attendanceCompletedTitle.snowyNight,
                            "currentBroadcastAttendanceCompletedBody": String.broadcast.attendanceCompletedBody.snowyNight,
                            "currentBroadcastAnnounce": (String.broadcast.announce.randomElement() ?? ""),
                            "stampLargeSkyImage": Image.assets.stampLarge.snowyNight,
                            "stampSmallSkyImage": Image.assets.stampSmall.snowyNight,
                            "stampBorderColor": Color.stampBorder.snowyNight]
            default: viewData = [:]
            }
        default: viewData = [:]
        }
        
        
        if isInputAttndanceRecord {
            //캘린더뷰에서 사용할 뷰데이터로 변환
            recordedEnvironmentViewData = EnvironmentRecordViewData(weather: environmentWeather, isWind: environmentIsWind, isThunder: environmentIsThunder, time: environmentTime, lottieImageName: viewData["lottieImageName"] as! String, colorOfSky: viewData["colorOfSky"] as! LinearGradient, colorOfGround: viewData["colorOfGround"] as! LinearGradient, broadcastAttendanceIncompleteTitle: "", broadcastAttendanceIncompleteBody: "", broadcastAttendanceCompletedTitle: "", broadcastAttendanceCompletedBody: "", broadcastAnnounce: "", stampLargeSkyImage: viewData["stampLargeSkyImage"] as! Image, stampSmallSkyImage: viewData["stampSmallSkyImage"] as! Image, stampBorderColor: viewData["stampBorderColor"] as! Color)
        } else {
            //실시간 뷰에 할당할 뷰데이터로 변환
            environmentViewData = EnvironmentRecordViewData(weather: environmentWeather, isWind: environmentIsWind, isThunder: environmentIsThunder, time: environmentTime, lottieImageName: viewData["lottieImageName"] as! String, colorOfSky: viewData["colorOfSky"] as! LinearGradient, colorOfGround: viewData["colorOfGround"] as! LinearGradient, broadcastAttendanceIncompleteTitle: viewData["currentBroadcastAttendanceIncompleteTitle"] as! String, broadcastAttendanceIncompleteBody: viewData["currentBroadcastAttendanceIncompleteBody"] as! String, broadcastAttendanceCompletedTitle: viewData["currentBroadcastAttendanceCompletedTitle"] as! String, broadcastAttendanceCompletedBody: viewData["currentBroadcastAttendanceCompletedBody"] as! String, broadcastAnnounce: viewData["currentBroadcastAnnounce"] as! String, stampLargeSkyImage: viewData["stampLargeSkyImage"] as! Image, stampSmallSkyImage: viewData["stampSmallSkyImage"] as! Image, stampBorderColor: viewData["stampBorderColor"] as! Color)
        }
    }
    
    func getHourFromDate(time: Date) -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        return hour
    }
}

