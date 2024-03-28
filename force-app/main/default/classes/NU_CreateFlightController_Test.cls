/**
 * @author Amal Ali-Muradbayli
 * @date 2024-03-28
 * @group Nubessom
 * @description Test class for the NU_CreateFlightController class.
*/
@isTest
public with sharing class NU_CreateFlightController_Test {


    /**
     * @description Test data setup method. 
     * For exercise, data is created inside method, but in real-world scenarios should be moved to separate class (TestDataFactory, etc.)
     */
    @TestSetup
    static void setup() {
        // Create and insert origin airport
        NU_Airport__c originAirport = new NU_Airport__c(
            Name = 'Origin Airport',
            NU_IATA_Code__c = 'ORG',
            NU_Location__Latitude__s = 37.7749,
            NU_Location__Longitude__s = -122.4194
        );
        insert originAirport;

        // Create and insert destination airport
        NU_Airport__c destinationAirport = new NU_Airport__c(
            Name = 'Destination Airport',
            NU_IATA_Code__c = 'DES',
            NU_Location__Latitude__s = 34.0522,
            NU_Location__Longitude__s = -118.2437
        );
        insert destinationAirport;
    }


    @isTest
    static void testSaveFlight() {

        User currentUser = new User(Id = UserInfo.getUserID());
        User userWithPermissions = null;
        System.runAs(currentUser) {
            //Create a test user with the required permission set
            String username = 'flightManager' + System.now().getTime() + '@test' + UserInfo.getOrganizationId() + '.org';
            User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id, LastName = 'last', Email = username,
                            Username = username, Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US');
            insert u;

            //"Flights Manager" is a permission set that was created for the exercise.
            //Provides the necessary permissions to manage flights/airports.
            insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionsetId = [SELECT Id FROM PermissionSet WHERE Name = 'Flights_Manager'].Id);
            userWithPermissions = u;
        }


        List<NU_Airport__c> airports = [SELECT Id, Name FROM NU_Airport__c LIMIT 2];
        NU_Airport__c originAirport = airports[0];
        NU_Airport__c destinationAirport = airports[1];
        String newFlightId = null;
        Test.startTest();
            System.runAs(userWithPermissions) {
                newFlightId = NU_CreateFlightController.saveFlight(airports[0].Id, airports[1].Id);
            }
        Test.stopTest();

        // Verify results
        NU_Flight__c savedFlight = [SELECT Id, NU_Origin__c, NU_Destination__c, NU_Distance__c FROM NU_Flight__c WHERE Id = :newFlightId];
        System.assertNotEquals(null, savedFlight, 'The flight record should be created.');
        System.assertEquals(originAirport.Id, savedFlight.NU_Origin__c, 'The origin airport should match.');
        System.assertEquals(destinationAirport.Id, savedFlight.NU_Destination__c, 'The destination airport should match.');
        
        // Assert that the distance is calculated correctly. This assertion depends on the correct calculation in the Apex class.
        // The distance between San Francisco and Los Angeles is approximately 559 kilometers.
        // Due to the simplicity of the Haversine formula and potential rounding differences, allow for some margin in the assertion.
        System.assert(Math.abs(savedFlight.NU_Distance__c - 559) < 10, 'The calculated distance should be approximately 559 kilometers.');
    }

}