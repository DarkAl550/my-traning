public virtual class TriggerHandler {
    
    public virtual void run(){
        if(Trigger.isInsert && Trigger.isBefore) beforeInsert();
        if(Trigger.isInsert && Trigger.isAfter) afterInsert();
        if(Trigger.isUpdate && Trigger.isBefore) beforeUpdate();
        if(Trigger.isUpdate && Trigger.isAfter) afterUpdate();
        if(Trigger.isDelete && Trigger.isBefore) beforeDelete();
        if(Trigger.isDelete && Trigger.isAfter) afterDelete();
    }

    protected virtual void beforeInsert(){}
    protected virtual void afterInsert(){}
    protected virtual void beforeUpdate(){}
    protected virtual void afterUpdate(){}
    protected virtual void beforeDelete(){}
    protected virtual void afterDelete(){}
}