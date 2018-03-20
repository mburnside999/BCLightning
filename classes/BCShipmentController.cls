public with sharing class BCShipmentController {
    
    private static String SHIPMENTURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment';
    private static String SHIPMENTRECEIVEDURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/ShipmentReceived';

    @AuraEnabled
    public static List<BCShipment__x> findAll() {
        return [SELECT ExternalId, class__c, type__c,status__c,contract__c,unitCount__c FROM BCShipment__x LIMIT 50];
    }
    
    @AuraEnabled
    public static List<BCShipment__x> findByName(String searchKey) {      
        
        return [SELECT ExternalId, class__c, type__c,status__c,contract__c,unitCount__c FROM BCShipment__x LIMIT 50];              
    }
    
    @AuraEnabled
    public static String BCShipmentReceived(String shipmentid) {

        BCShipment__x shipment=[select ShipmentId__c,type__c,status__c,unitCount__c,contract__c from BCShipment__x where ShipmentId__c=:shipmentid limit 1];

        //shipment.status__c='ARRIVED';

        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(SHIPMENTRECEIVEDURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String body;
        body='{"$class": "org.acme.shipping.perishable.ShipmentReceived"';
        body+=',';
        body+='"shipment":"resource:org.acme.shipping.perishable.Shipment#'+shipmentid+'"';
        body+='}';
        req.setBody(body);
        req.setMethod('POST');
        res = h.send(req);

        if  (res.getStatusCode() == 200)
            return body;
        else
                throw new AuraHandledException(res.getBody());
        

    }
    
    
    @AuraEnabled
    public static BCShipment__x findById(String externalId) {
        return [SELECT ExternalId, type__C,class__c, status__c
                FROM BCShipment__x WHERE Externalid = :externalId];
    }

    @AuraEnabled
    public static String saveShipment(BCShipment__x shipment) {

        /*
        {
  "$class": "org.acme.shipping.perishable.Shipment",
  "shipmentId": "5460",
  "type": "BANANAS",
  "status": "CREATED",
  "unitCount": 0,
  "contract": "resource:org.acme.shipping.perishable.Contract#4650"
}
         */


        String body;
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(SHIPMENTURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        body='{"$class": "org.acme.shipping.perishable.Shipment"';
        body+=',';
        body+='"shipmentId":"'+shipment.ShipmentId__c+'"';
        body+=',';
        body+='"type":"'+shipment.type__c+'"';
        body+=',';
        body+='"status":"'+shipment.status__c+'"';
        body+=',';
        body+='"unitCount":"'+shipment.unitCount__c+'"';
        body+=',';
        body+='"contract":"resource:org.acme.shipping.perishable.Contract#'+shipment.contract__c+'"';
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