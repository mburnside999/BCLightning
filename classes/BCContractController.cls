public class BCContractController {

    private static String CONTRACTURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Contract';

    @AuraEnabled
    public static List<BCContract2__x> findAll() {
        return [SELECT ExternalId, grower__c,shipper__c,importer__c,unitPrice__c,minTemperature__c,maxTemperature__c,minPenaltyFactor__c,maxPenaltyFactor__c,arrivalDateTime__c from BCContract2__x];
    }
   @AuraEnabled
    public static List<BCContract2__x> findByShipmentID(String searchKey) { 
        BCShipment__x bcs=[select contract__c from BCShipment__x where ExternalId=:searchKey];
        String contract=bcs.contract__c;
        return [SELECT ExternalId, grower__c,shipper__c,importer__c,unitPrice__c,minTemperature__c,maxTemperature__c,minPenaltyFactor__c,maxPenaltyFactor__c,arrivalDateTime__c FROM BCContract2__x where contractId__c=:contract];
    }

    @AuraEnabled
    public static String saveContract(BCContract2__x contract) {

        String body;
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CONTRACTURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        body='{"$class": "org.acme.shipping.perishable.Contract"';
        body+=',';
        body+='"contractId":"'+contract.ExternalId+'"';
        body+=',';
        body+='"grower":"resource:org.acme.shipping.perishable.Grower#'+contract.grower__c+'"';
        body+=',';
        body+='"importer":"resource:org.acme.shipping.perishable.Importer#'+contract.importer__c+'"';
        body+=',';
        body+='"shipper":"resource:org.acme.shipping.perishable.Shipper#'+contract.shipper__c+'"';
        body+=',';
        body+='"arrivalDateTime":"'+contract.arrivalDateTime__c+'"';
        body+=',';
        body+='"unitPrice":"'+contract.unitPrice__c+'"';
        body+=',';
        body+='"minTemperature":"'+contract.minTemperature__c+'"';
        body+=',';
        body+='"maxTemperature":"'+contract.maxTemperature__c+'"';
        body+=',';
        body+='"minPenaltyFactor":"'+String.valueOf(contract.minPenaltyFactor__c)+'"';
        body+=',';
        body+='"maxPenaltyFactor":"'+String.valueOf(contract.maxPenaltyFactor__c)+'"';


        body+='}';


        req.setBody(body);
        req.setMethod('POST');
        res = h.send(req);

        if  (res.getStatusCode() == 200)
            return body;
        else
                throw new AuraHandledException(res.getBody() );


    }


}