public class UtilityCase{

   
   
    //Mappa i record type sull'oggetto
    static Map<Id,RecordType> recordTypeMap = new Map<Id, RecordType>([SELECT id, name FROM RecordType WHERE SobjectType = 'Case']);

    //Lista degli attestati di rischio da aggiornare
    static List<AttestatoDiRischio__c> attList;

    //Mappa l'id di un libretto con la descrizione del case che lo riguarda
    static Map<Id,String> toGetLib = new Map<Id, String>();

    
    
    //Aggiorna la classe di rischio
    private static void setRiskClass(AttestatoDiRischio__c att){
        if (att.ClassediRischio__c > 16){
            att.ClassediRischio__c = 18;
        }
        else{
            att.ClassediRischio__c = att.ClassediRischio__c + 2;
        }
    }

    //Aggiorna la sinistrosità pregressa
    private static void setCrashHistory(AttestatoDiRischio__c att, String description){
        if (att.SinistrositaPregressa__c == null){
            att.SinistrositaPregressa__c = description;
        }
        else{
            att.SinistrositaPregressa__c = att.SinistrositaPregressa__c + '\n' + description;
        }
    }

    //Seleziona i libretti da aggiornare
    private static void chooseLib(Case c){

        if(recordTypeMap.get(c.RecordTypeId).Name == 'Incidente' && c.Status == 'Closed' && c.Guilt__c > 0.50){
            toGetLib.put(c.Libretto__c, c.Description);
        }
        
    }

    //Aggiorna la descrizione degli attestati di rischio con i relativi incidenti
    public static void updateDescription(List<Case> cases){
       
        for(Case c : cases){
            chooseLib(c);
        }

        //Recupera gli Attestati i cui libretti sono stati selezionati
        attList = [SELECT Name, CreatedDate, SinistrositaPregressa__c, Libretto__c, ClassediRischio__c FROM AttestatoDiRischio__c WHERE Libretto__r.Id IN :toGetLib.keySet()];
        
        for(AttestatoDiRischio__c att : attList ){
            setRiskClass(att);
            setCrashHistory(att, toGetLib.get(att.Libretto__c));
        }

        Database.update(attList, false);
        
    }
    
    
    
    
    
}