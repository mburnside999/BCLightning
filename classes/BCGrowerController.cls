public class BCGrowerController {

    private static String GROWERURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Grower';



    @AuraEnabled
    public static List<BCGrower__x> findAll(String ExternalId) {
        return [SELECT ExternalId,accountPK__c,accountBalance__c,street__c,city__c,country__c from BCGrower__x];
    }


    @AuraEnabled
    public static List<BCGrower__x> findGrowerByShipmentID(String searchKey) {

        BCShipment__x bcs=[select contract__c from BCShipment__x where ExternalId=:searchKey];
        String contract=bcs.contract__c;
        System.debug('Contract '+contract);

        BCContract2__x bcg=[select grower__c from BCContract2__x where ExternalId=:contract ];
        String grower=bcg.grower__c;
        System.debug('Grower '+grower);

        return [SELECT ExternalId, accountPK__c,companyName__c,accountBalance__c,street__c,city__c,country__c FROM BCGrower__x where ExternalId=:grower];
    }

    @AuraEnabled
    public static String saveGrower(BCGrower__x grower) {

        String body;
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(GROWERURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        body='{"$class": "org.acme.shipping.perishable.Grower","accountPK":"'+grower.accountPK__c+'","companyName":"'+grower.companyName__c+'","email":"'+grower.email__c+'", "address": { "$class": "org.acme.shipping.perishable.Address","city":"'+grower.city__c+'","street":"'+grower.street__c+'","country":"'+grower.country__c+'"},"accountBalance":"'+grower.accountBalance__c+'"}';

        req.setBody(body);
        req.setMethod('POST');
        res = h.send(req);

        if  (res.getStatusCode() == 200)
            return body;
        else
                throw new AuraHandledException(res.getBody() );


    }

}