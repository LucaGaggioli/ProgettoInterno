trigger CaseTrigger on Case (after update) {
    
    switch on Trigger.OperationType {
        when AFTER_UPDATE {
            UtilityTrigger.updateDescription(Trigger.New);
        }
    }
    
}