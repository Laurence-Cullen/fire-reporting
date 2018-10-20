import Foundation
import FirebaseFirestore

protocol DocumentSerializable  {
    init?(dictionary:[String:Any])
}

struct Report {
    var uid:String
    var eventID: String
    var geoLocation : GeoPoint
    var lat: Double
    var lon: Double
    var imageURL : String
    var description: String
    var createdAt: Date
    var updatedAt: Date
    
    
    var dictionary:[String:Any] {
        return [
         
            "uid" : uid,
            "eventID": eventID,
            "lat": lat,
            "lon": lon,
            "geoLocation":geoLocation,
            "imageURL":imageURL,
            "description":description,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]
    }
}

extension Report : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let
           
           eventID = dictionary["eventID"] as? String,
           
            let uid = dictionary ["uid"] as? String,
            let geoLocation = dictionary["geoLocation"] as? GeoPoint,
            let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double,
            let imageURL = dictionary["imageURL"] as? String,
            let description = dictionary["description"] as? String,
            let createdAt = dictionary["createdAt"] as? Date,
            let updatedAt = dictionary["updatedAt"] as? Date



        
            else {return nil}
        
        self.init(uid: uid, eventID: eventID, geoLocation:geoLocation, lat:lat, lon:lon, imageURL: imageURL, description: description,  createdAt:createdAt, updatedAt:updatedAt)
    }
}



