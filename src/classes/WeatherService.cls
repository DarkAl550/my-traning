//TODO: Create Weather Service
public with sharing class WeatherService{
    
    public static void getWetherParams(String city){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(getEndpoint(city));
        request.setMethod('GET');
        request.setTimeout(60000);
        HttpResponse response = new Http().send(request);
        Map<String, Object> responseResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        switch on (responseResult.get('cod').toString()) {
            when '200' {
                createForecasts(responseResult);
            }
            when '404'{
                System.debug('City not found');
            }
            when '401'{
                System.debug('Invalid API Key! Connect with your sysadmin');
            }
            when else {
                System.debug('Error');
            }
        }        
        

    }
    private static String getEndpoint(String city) {
        Map<String, OpenWeatherMap_Setting__mdt> metadataSettings = OpenWeatherMap_Setting__mdt.getAll();
        return metadataSettings.get('OpenWeatherMap_Setting').get('API_Service__c') + city + metadataSettings.get('OpenWeatherMap_Setting').get('API_Key__c');
    }
    //TODO: Fix this method 
    private static void createForecasts(Map<String, Object> responseMap){
        List<Forecast__c> forecasts = new List<Forecast__c>();
        List<Object> lists = (List<Object>) responseMap.get('list');
        Map<String, Object> cityMap = (Map<String, Object>) responseMap.get('city');
        List<Map<String, Object>> forecastsMap = new List<Map<String, Object>>();
        for(Object obj : lists){
            forecastsMap.add((Map<String, Object>) obj);
        }
        City__c city = setCity(cityMap);
        System.debug(city);
        for(Map<String, Object> forecastMap : forecastsMap){
            Map<String, Object> main = (Map<String, Object>) forecastMap.get('main');
            Map<String, Object> wind = (Map<String, Object>) forecastMap.get('wind');
            List<Map<String, Object>> weathers = new List<Map<String,Object>>();
            for(Object obj : (List<Object>)forecastMap.get('weather')){
                weathers.add((Map<String, Object>) obj);
            }
            Forecast__c forecast = new Forecast__c(Name = cityMap.get('name').toString() + ' ' + forecastMap.get('dt_txt').toString(),
                                                    City__c = city.Id);
            forecasts.add(forecast);

        }
        System.debug('forecasts' + forecasts.size());
        System.debug(forecasts);

        
        
    }
    private static City__c setCity(Map<String,Object> cityMap){
        List<City__c> cities = [
                                SELECT Name
                                FROM City__c
                                WHERE Name = :cityMap.get('name').toString()
        ];
        if(cities.isEmpty()){
            return createCity(cityMap);
        }
        if(!cities.isEmpty()){
            return cities[0];
        }
        return null;
    }

    private static City__c createCity(Map<String,Object> cityMap){
        City__c newCity = new City__c();
        newCity.Name = cityMap.get('name').toString();
        Map<String, Object> coord = (Map<String,Object>) cityMap.get('coord');
        insert newCity; 
        return newCity;
    }
}