public class BCImporterController {


    private static String IMPORTERURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Importer';

    @AuraEnabled
    public static List<BCImporter__x> findAll(String ExternalId) {
        return [SELECT ExternalId,accountPK__c,companyName__c,accountBalance__c,street__c,city__c,country__c from BCImporter__x];
    }
    
    
    @AuraEnabled
    public static List<BCImporter__x> findImporterByShipmentID(String searchKey) { 
        
        BCShipment__x bcs=[select contract__c from BCShipment__x where ExternalId=:searchKey];
        String contract=bcs.contract__c;
        System.debug('Contract '+contract);
        
        BCContract2__x bci=[select importer__c from BCContract2__x where ExternalId=:contract ];
        String importer=bci.importer__c;
        System.debug('Importer '+importer);
       
        return [SELECT ExternalId, accountPK__c,companyName__c,accountBalance__c,street__c,city__c,country__c FROM BCImporter__x where ExternalId=:importer];
    }


    @AuraEnabled
    public static String saveImporter(BCImporter__x importer) {

        String body;
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(IMPORTERURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        body='{"$class": "org.acme.shipping.perishable.Importer","accountPK":"'+importer.accountPK__c+'","companyName":"'+importer.companyName__c+'","email":"'+importer.email__c+'", "address": { "$class": "org.acme.shipping.perishable.Address","city":"'+importer.city__c+'","street":"'+importer.street__c+'","country":"'+importer.country__c+'"},"accountBalance":"'+importer.accountBalance__c+'"}';

        req.setBody(body);
        req.setMethod('POST');
        res = h.send(req);

        if  (res.getStatusCode() == 200)
            return body;
        else
                throw new AuraHandledException(res.getBody() );

    }


}

}

}
    
}