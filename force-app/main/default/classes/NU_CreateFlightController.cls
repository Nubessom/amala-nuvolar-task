/**
 * @author Amal Ali-Muradbayli
 * @date 2024-03-28
 * @group Nubessom
 * @description Controller class for createFlight lwc component
 * @task Implement the logic to save the flight record with the distance between the origin and destination airports in kilometers
*/
public with sharing class NU_CreateFlightController {
    
    /**
     * @description Method to save the flight record with the distance between the origin and destination airports in kilometers
     * @param originAirportId - Id of the origin airport
     * @param destinationAirportId - Id of the destination airport
     * @return Id of the newly created flight record
    */
    @AuraEnabled
    public static String saveFlight(String originAirportId, String destinationAirportId) {
        try {
            List<NU_Airport__c> airports = [SELECT NU_Location__c FROM NU_Airport__c WHERE Id IN :new List<Id>{originAirportId, destinationAirportId} WITH USER_MODE];

            //Order of the airports is not important, as we are calculating the distance between them
            Location originLocation = airports[0].NU_Location__c;
            Location destinationLocation = airports[1].NU_Location__c;

            // Calculate the distance between the two airports in meters
            Decimal distanceInMeters = calculateDistance(originLocation.latitude, originLocation.longitude, destinationLocation.latitude, destinationLocation.longitude);
            //Should be converted to km, as per Excersice requirement
            Decimal distanceInKm = distanceInMeters / 1000;

            NU_Flight__c newFlight = new NU_Flight__c();
            newFlight.NU_Origin__c = originAirportId;
            newFlight.NU_Destination__c = destinationAirportId;
            newFlight.NU_Distance__c = distanceInKm;
            insert AS USER newFlight;
            return newFlight.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }

    /**
     * @description Method to calculate the distance between two locations using the Haversine formula
     * @param latitude1 - Latitude of the first location
     * @param longitude1 - Longitude of the first location
     * @param latitude2 - Latitude of the second location
     * @param longitude2 - Longitude of the second location
     * @return Distance between the two locations in meters
     */
    private static Decimal calculateDistance(Decimal latitude1, Decimal longitude1, Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; 
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) + Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) * Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in metres
        return distance;
    }
}