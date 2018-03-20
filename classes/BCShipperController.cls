public class BCShipperController {


    private static String SHIPPERURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipper';

    @AuraEnabled
    public static List<BCShipper__x> findAll(String ExternalId) {
        return [SELECT ExternalId,accountPK__c,companyName__c,accountBalance__c,street__c,city__c,country__c from BCShipper__x];
    }


    @AuraEnabled
    public static List<BCShipper__x> findShipperByShipmentID(String searchKey) {

        BCShipment__x bcs=[select contract__c from BCShipment__x where ExternalId=:searchKey];
        String contract=bcs.contract__c;
        System.debug('Contract '+contract);

        BCContract2__x bci=[select shipper__c from BCContract2__x where ExternalId=:contract ];
        String shipper=bci.shipper__c;
        System.debug('Shipper '+shipper);

        return [SELECT ExternalId, accountPK__c,companyName__c,accountBalance__c,street__c,city__c,country__c FROM BCShipper__x where ExternalId=:shipper];
    }


    @AuraEnabled
    public static String saveShipper(BCShipper__x shipper) {

        String body;
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(SHIPPERURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        body='{"$class": "org.acme.shipping.perishable.Shipper","accountPK":"'+shipper.accountPK__c+'","companyName":"'+shipper.companyName__c+'","email":"'+shipper.email__c+'", "address": { "$class": "org.acme.shipping.perishable.Address","city":"'+shipper.city__c+'","street":"'+shipper.street__c+'","country":"'+shipper.country__c+'"},"accountBalance":"'+shipper.accountBalance__c+'"}';

        req.setBody(body);
        req.setMethod('POST');
        res = h.send(req);

        if  (res.getStatusCode() == 200)
            return body;


        else
                throw new AuraHandledException(res.getBody() );


    }



}