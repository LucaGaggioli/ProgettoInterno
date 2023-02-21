public class ResetOrg {

    private static RecordType rt = [SELECT Id FROM RecordType WHERE name = 'Incidente' LIMIT 1];
    private static List<Account> accList = new List<Account>();
    private static List<Contact> contList = new List<Contact>();
    private static List<Opportunity> oppList = new List<Opportunity>();
    private static List<Libretto__c> libList = new List<Libretto__c>();
    private static List<Case> caseList = new List<Case>();
    private static List<AttestatoDiRischio__c> attList = new List<AttestatoDiRischio__c>();
    private static List<Product2> prodList = new List<Product2>();

    
    private static Integer c = 0;
    private static Integer d = 0;
    private static Integer u = -1;



    //Popola la org con dei record di prova
    public static void reset(Integer n){

        If(n < 333){

            addAccount(n);
            addContact();
            addOpportunity();
            addLibretti();
            addCase();
            addAttestati();
            addProduct();

        }

    }


    //Svuota la org da ogni record
    public static void clear(){

        delProduct();
        delAttestati();
        delCase();
        delLibretti();
        delOpportunity();
        delContact();
        delAccount();

    }





    //Inserisce un numero specificato di Account
    private static void addAccount(Integer n){


        for (Integer i = 0; i < n; i++) {
            accList.add(new Account(name = 'Account ' + i));
        }

        Database.insert(accList,true);

    }

    //Inserisce un numero specificato di Contact
    private static void addContact(){

        Integer n  = accList.size()*3;

        for (Integer i = 0; i < n; i++) {
            contList.add(new Contact(lastName = 'Contact ' + i, accountId = accList[i/3].Id));
        }

        Database.insert(contList, true);

    }

    //Inserisce le Opportunity
    private static void addOpportunity(){

        for (Integer i = 0; i < accList.size(); i++) {
            oppList.add(new Opportunity(name = 'Opportunity ' + i, accountId = accList[i].Id, stageName = 'Closed Won', closeDate = System.today()));
        }

        Database.insert(oppList, true);

    }

    private static String nextTarga(){
        if (u == -1) {
            return String.valueOf(c) + String.valueOf(d) + String.valueOf(++u);
        }
        u = Math.mod(++u, 10);
        if (u == 0) {
            d = Math.mod(++d, 10);
            if (d == 0) {
                c++;
            }
        }
        return String.valueOf(c) + String.valueOf(d) + String.valueOf(u);

    }

    //Inserisci i Libretti
    private static void addLibretti(){

        for (Integer i = 0; i < contList.size(); i++) {

            libList.add(new Libretto__c(Name = 'Libretto ' + i,
                                        Targa__c = 'ab' + nextTarga() + 'ab',
                                        Tipo_Veicolo__c='Autovetture',
                                        Cilindrata__c=1500,
                                        Anno__c = Date.newInstance(2016, 12, 9),
                                        Potenza__c = 100,
                                        Opportunity__c = oppList[i/3].Id));

        }
        
        Database.insert(libList, true);

    }

    //Inserisce i Case
    private static void addCase(){

        for (Integer i = 0; i < libList.size(); i++){

            caseList.add(new Case(accountID = accList[i/3].Id, 
                                contactId = contList[i].Id,
                                Libretto__c = libList[i].Id,
                                recordTypeID = rt.Id));

        }
        Database.insert(caseList, true);

    }

    //Inserisce dei Product
    private static void addProduct(){

        for (Integer i = 0; i < 5; i++) {
            prodList.add(new Product2(name = 'Prodotto ' + i, TettoMassimo__c = 10000));
        }

        Database.insert(prodList);

    }


    //Elimina i Product
    private static void delProduct(){

        List<Product2> prodList = [SELECT Id FROM Product2];

        Database.delete(prodList, false);
    
    }

    //Inserisce gli Attestati Di Rischio
    private static void addAttestati(){


        for (Integer i = 0; i < libList.size(); i++) {
            attList.add(new AttestatoDiRischio__c(Name = 'Attestato ' + i, Libretto__c = libList[i].Id));
        }

        Database.insert(attList, true);

    }

    //Elmina tutti gli attestati
    private static void delAttestati(){

        List<AttestatoDiRischio__c> attList = [SELECT Id FROM AttestatoDiRischio__c];

        Database.delete(attList, false);

    }

    //Elimina tutti i Case
    private static void delCase(){

        List<Case> caseList = [SELECT Id FROM Case];

        Database.delete(caseList, false);

    }

    //Elimina tutti i libretti
    private static void delLibretti(){

        List<Libretto__c> libList = [SELECT Id FROM Libretto__c];

        Database.delete(libList, true);

    }

    //Elimina tutte le opportunity
    private static void delOpportunity(){

        List<Opportunity> oppList = [SELECT Id FROM Opportunity];

        Database.delete(oppList, false);

    }


    //Elimina tutti i contatti
    private static void delContact(){

        List<Contact> contList = [SELECT Id FROM Contact];

        Database.delete(contList, false);


    }

    //Elimina tutti gli account
    private static void delAccount(){

        List<Account> accList = [SELECT Id FROM Account];

        Database.delete(accList, false);

    }


}