trigger ForecastTrigger on Forecast__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new ForecastTriggerHandler().run();
}