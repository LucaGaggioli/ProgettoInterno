trigger CaseTrigger on Case (after update) {
    
    switch on Trigger.OperationType {
        when AFTER_UPDATE {
            UtilityCase.updateDescription(Trigger.New);
        }
    }
    
}