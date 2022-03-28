public with sharing class ForecastTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        List<Forecast__c> duplicatedForecasts = new List<Forecast__c>();
        List<Forecast__c> currentForecasts = new List<Forecast__c>();
        for(sObject forecast : Trigger.new){
            Forecast__c currentForecast = (Forecast__c)forecast;
            currentForecasts.add(currentForecast);
        }
        for(Forecast__c duplicate : [SELECT Id, Name, City__c FROM Forecast__c]){
            for(Forecast__c currentForecast : currentForecasts){
                if(currentForecast.City__c == duplicate.City__c 
                    && currentForecast.Name == duplicate.Name) {
                        duplicatedForecasts.add(duplicate);
                }
            }
        }
        if(duplicatedForecasts.size() > 0) delete duplicatedForecasts;
    }
}