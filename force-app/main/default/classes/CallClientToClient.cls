public with sharing class CallClientToClient {
     public static HttpResponse callOutExt() {
    http http=new http();
        HttpRequest req=new HttpRequest();
        req.setHeader('Authorization', 'Bearer '+UserInfo.getSessionID());
        req.setEndpoint('https://digitalityconsulting83-dev-ed.develop.my.salesforce.com/services/data/v56.0/tooling/query/?q=select+id,assigneeid+from+PermissionSetAssignment+where+PermissionSetid+in+(select+principalId+from+ExternalCredentialParameter)');

        req.setMethod('GET');
        System.debug(req);

        HttpResponse resp=http.send(req);
        system.debug(resp.getBody());
         

        if(resp.getStatusCode()==200){
            system.debug(resp.getBody());
        }

        return resp;

    }



}