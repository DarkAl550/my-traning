public with sharing class WeatherWidgetController {
    public static List<Forecast__c> getForecasts(String city){
        List<Forecast__c> forecasts = [
                                        SELECT Name
                                        FROM Forecast__c
                                        WHERE City__r.Name = :city
        ];
        return forecasts;
    }
}