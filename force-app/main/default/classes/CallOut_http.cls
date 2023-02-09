public with sharing class CallOut_http {

    //Controlla che sia possibile effettuare callout
    @AuraEnabled
    public static Boolean checkPermissions(String url){

        http http=new http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint(url + '?check=0');
        req.setMethod('GET');

        HttpResponse resp=http.send(req);
        return (resp.getStatusCode()==200);
    }

    //Restituisce tutti gli account
    @AuraEnabled
    public static List<Account> getAllAccount(String url) {
       
        http http=new http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint(url + '?check=1');
        req.setMethod('GET');
        HttpResponse resp=http.send(req);

        if(resp.getStatusCode()==200){
            return (List<Account>) JSON.deserialize(resp.getBody(), List<Account>.class);
        }

        return null;
    }

    //Restituisce tutte le opportunity
    @AuraEnabled
    public static List<Opportunity> getAllOpportunity(String url) {
       
        http http=new http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint(url + '?check=2');
        req.setMethod('GET');
        HttpResponse resp=http.send(req);

        if(resp.getStatusCode()==200){
            return (List<Opportunity>) JSON.deserialize(resp.getBody(), List<Opportunity>.class);
        }

        return null;
    }

    @AuraEnabled
    public static List<lead> getAllLead(String url) {
       
        http http=new http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint(url + '?check=3');
        req.setMethod('GET');
        HttpResponse resp=http.send(req);

        if(resp.getStatusCode()==200){
            return (List<lead>) JSON.deserialize(resp.getBody(), List<lead>.class);
        }

        return null;
    }

    //Crea un nuovo Account
    @AuraEnabled
    public static Boolean postAccount(String url, String account){

        http http=new http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint(url + '?check=0');
        req.setMethod('POST');
        req.setBody(account);

        HttpResponse resp=http.send(req);

        return (resp.getStatusCode()==200 && resp.getBody() == 'true');
        
    }

}