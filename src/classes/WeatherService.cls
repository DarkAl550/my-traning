//TODO: Create Weather Service
public with sharing class WeatherService{
    
    public static void getWetherParams(String city){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(getEndpoint(city));
        request.setMethod('GET');
        request.setTimeout(60000);
        HttpResponse response = new Http().send(request);
        Map<String, Object> responseResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        //TODO: fix switch or create alternative
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
    //TODO: update this method 
    private static void createForecasts(Map<String, Object> responseMap){
        List<Forecast__c> forecasts = new List<Forecast__c>();
        List<Object> lists = (List<Object>) responseMap.get('list');
        Map<String, Object> cityMap = (Map<String, Object>) responseMap.get('city');
        List<Map<String, Object>> forecastsMap = new List<Map<String, Object>>();
        for(Object obj : lists){
            forecastsMap.add((Map<String, Object>) obj);
        }
        City__c city = setCity(cityMap);
        for(Map<String, Object> forecastMap : forecastsMap){
            Map<String, Object> main = (Map<String, Object>) forecastMap.get('main');
            Map<String, Object> wind = (Map<String, Object>) forecastMap.get('wind');
            List<Map<String, Object>> weathers = new List<Map<String,Object>>();
            for(Object obj : (List<Object>)forecastMap.get('weather')){
                weathers.add((Map<String, Object>) obj);
            }
            Forecast__c forecast = new Forecast__c();
            forecast.Name = cityMap.get('name').toString() + ' ' + forecastMap.get('dt_txt').toString();
            forecast.City__c = city.Id;
            forecast.Temperature__c = Double.valueOf(main.get('temp')) - 273.15;
            forecast.Wind_Speed__c = Double.valueOf(wind.get('speed'));
            forecast.Pressure__c = Double.valueOf(main.get('pressure'));
            forecast.Humidity__c = Double.valueOf(main.get('humidity'));
            forecast.Icon__c = 'https://openweathermap.org/img/wn/'+weathers[0].get('icon')+'@2x.png';
            forecast.Title__c = weathers[0].get('main').toString();
            forecast.Description__c = weathers[0].get('description').toString();
            forecast.Date_Time__c = Datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0).addSeconds((Integer)forecastMap.get('dt'));
            forecasts.add(forecast);
        }
        System.debug(forecasts);
        insert forecasts;        
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
        newCity.Country__c = cityMap.get('country').toString();
        insert newCity; 
        return newCity;
    }
}