public class UtilityTrigger{
//Aggiorna la descrizione dell'attestato di rischio con il nuovo incidente
    public static void updateDescription(List<Case> cases){
        
        Map<Id,RecordType> recordTypeMap = new Map<Id, RecordType>([SELECT id, name FROM RecordType WHERE SobjectType = 'Case']);
        Map<Id,String> toGetLib = new Map<Id, String>();
        List<AttestatoDiRischio__c> attList;
       
        for(Case c : cases){
            if(recordTypeMap.get(c.RecordTypeId).Name == 'Incidente' && c.Status == 'Closed' && c.Guilt__c > 0.50){
                toGetLib.put(c.Libretto__c, c.Description);
                
            }
            
        }
        attList = [SELECT Name, SinistrositaPregressa__c, Libretto__c, ClassediRischio__c FROM AttestatoDiRischio__c WHERE Libretto__r.Id IN :toGetLib.keySet()];
        for(AttestatoDiRischio__c att : attList ){
           
            if (att.ClassediRischio__c > 16){
                att.ClassediRischio__c = 18;
            }
            else{
                att.ClassediRischio__c = att.ClassediRischio__c+2;
            }
            if (att.SinistrositaPregressa__c == null){
                att.SinistrositaPregressa__c = toGetLib.get(att.Libretto__c);
            }
            else{
                att.SinistrositaPregressa__c = att.SinistrositaPregressa__c + '\n' + toGetLib.get(att.Libretto__c);
            }
          
            
        }
        Database.update(attList, false);
        
    }
    
    
    
    
    
}