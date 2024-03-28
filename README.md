# Nuvolar Exercise Project

    Created LWC Component, that accepts two airport locations with record picker (search could be performed both by IATA code and airport name).
    When saved new Flight record is created, with choosen locations as origin and destination. 
    Additionally calculates and saves Distance between those locations displayed in KM(kilometrs).

# Instalation:

    * Download Repository
        git clone <REPOSITORY_URL>
        cd <REPOSITORY_DIRECTORY>
    * Create Scratch Org
        sfdx force:org:create -f config/project-scratch-def.json -s -a ExerciseAmalaDemoOrg --durationdays 7
    * Push Source to Scratch Org
        sfdx force:source:push -u ExerciseAmalaDemoOrg
    * Open Scratch Org
        sfdx force:org:open -u ExerciseAmalaDemoOrg
    * Data Upload 
        1. In "data" folder locate iata-icao.csv file, that was used to generate airport data for this exercise.
        2. In Scratch org From Setup navigate to Data Import Wizard
        3. Use csv file to create new records.
        4. Object should be NU_Airport__c.
        5. Fields mapping (CSV (left) To Object(right)):
            country_code -> Country Code
            iata -> IATA Code
            airport -> Airport Name
            location -> Location
        6. Validate Records Created
    * Navigate to the Service Applications Home Page
        After your scratch org opens in your browser, use the App Launcher to navigate to the "Service Applications" app. 
        Here, you should find the Exercise_Demo_Home_Page Flexipage. LWC component named nu_createFlight should be visible on this page.
        

# Components List:

 * Flexipages:
    Exercise_Demo_Home_Page.flexipage-meta
 * lwc:
    nu_createFlight
 * classes:
    NU_CreateFlightController_Test.cls
    NU_CreateFlightController.cls
 * objects: 
    NU_Airport__c
    NU_Flight__c
 * permissionsets:
    Flights_Manager.permissionset-meta
 * tabs:
    standard-home.tab-meta