@isTest
public with sharing class WeatherServiceTest {
    @isTest 
    static void testGetWeatherParams(){
        System.Test.setMock(HttpCalloutMock.class, new WeatherServiceMock());
        WeatherService.getWetherParams('Minsk');
        List<City__c> createdCity = [SELECT Name
                                        FROM City__c];
        for(City__c city : createdCity){
            System.assertEquals('Minsk', city.Name);
        }
        List<Forecast__c> createdForecasts = [
                                                SELECT Name
                                                FROM Forecast__c
        ];
        System.assertEquals(createdForecasts.size(), 40);
    }
}