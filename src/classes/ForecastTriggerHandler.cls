public with sharing class ForecastTriggerHandler extends TriggerHandler{
    protected override void beforeInsert(){
        List<Forecast__c> currentForecasts = new List<Forecast__c>();
        for(sObject forecast : Trigger.new){
            Forecast__c currentForecast = (Forecast__c)forecast;
            currentForecasts.add(currentForecast);
        }
        deleteDuplicatedRecords(currentForecasts);
        deleteOldRecords(currentForecasts);
    }

    private static void deleteDuplicatedRecords(List<Forecast__c> currentForecasts){
        List<Forecast__c> duplicatedForecasts = new List<Forecast__c>();
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
    
    private static void deleteOldRecords(List<Forecast__c> currentForecasts){
        List<Forecast__c> oldForecasts = new List<Forecast__c>();
        for(Forecast__c oldForecast : [SELECT Id, Date_Time__c, City__c FROM Forecast__c WHERE Date_Time__c < TODAY]){
            for(Forecast__c currentForecast : currentForecasts){
                if(currentForecast.City__c == oldForecast.City__c) oldForecasts.add(oldForecast);
            } 
        }
        if(oldForecasts.size() > 0) delete oldForecasts;
    }
}