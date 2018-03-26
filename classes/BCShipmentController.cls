public with sharing class BCShipmentController {
    
    private static String SHIPMENTURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment';
    private static String SHIPMENTRECEIVEDURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/ShipmentReceived';
    private static String SHIPMENTINTRANSITURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/ShipmentInTransit';
    private static String SHIPMENTPACKEDURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/ShipmentPacked';
    private static String TEMPERATUREREADINGURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/TemperatureReading';

    @AuraEnabled
    public static List<BCShipment__x> findAll() {
        return [SELECT ExternalId, class__c, type__c,status__c,contract__c,unitCount__c FROM BCShipment__x LIMIT 50];
    }
    
    @AuraEnabled
    public static List<BCShipment__x> findByName(String searchKey) {      
        
        return [SELECT ExternalId, class__c, type__c,status__c,contract__c,unitCount__c FROM BCShipment__x LIMIT 50];              
    }

    @AuraEnabled
    public static BCShipment__x findByShipmentId(String shipment) {

        return [SELECT ExternalId, shipmentId__c,class__c, type__c,status__c,contract__c,unitCount__c FROM BCShipment__x where ShipmentId__c=:shipment LIMIT 1];
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
    public static String generateTemperatures(String shipmentid, Integer loopcount, Boolean inrange) {


        BCShipment__x shipment=[select contract__c from BCShipment__x where ExternalId=:shipmentid limit 1];
        String contract=shipment.contract__c;

        BCContract2__x bccontract= [select  id,maxTemperature__c,minTemperature__c from BCContract2__x where ExternalId=:contract limit 1 ];

        System.debug('max tempersture '+ bccontract.maxTemperature__c);
        System.debug('min tempersture '+ bccontract.minTemperature__c);

        Integer diff=integer.valueOf(bccontract.maxTemperature__c)-integer.valueOf(bccontract.minTemperature__c);
        System.debug(integer.valueOf(bccontract.maxTemperature__c)-integer.valueOf(bccontract.minTemperature__c));


        Double d;
        Decimal dc;
        String str_dc;

        String str_t;
        try {
            for (Integer i = 0; i < loopcount; i++) {

                DateTime t = DateTime.now().addMinutes(-30 * i);
                d = Math.random();
                if (inrange) {
                    dc = Decimal.valueOf(bccontract.minTemperature__c) + Decimal.valueOf(d * diff);
                } else {

                    dc = Decimal.valueOf(bccontract.maxTemperature__c) + Decimal.valueOf(d * 5);
                }

                dc = dc.setScale(1);
                str_dc = dc.toPlainString();
                str_t = t.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
                System.debug('processing loop '+i);
                System.debug('str_dc= '+str_dc+ ' str_t='+str_t);
                BCAddTemperatureReading(shipmentid, str_dc, str_t);
            }

        }  catch (Exception e) {
            throw e;
        }
        //BCAddTemperatureReading(shipmentid,"1.0") ;
/*try {
    d = Math.random();
    dc = Decimal.valueOf(bccontract.minTemperature__c)+Decimal.valueOf(d * diff);
    dc = dc.setScale(1);
    str_dc = dc.toPlainString();
    BCAddTemperatureReading(shipmentid, str_dc, str_t);

    d = Math.random();
    dc = Decimal.valueOf(bccontract.minTemperature__c)+Decimal.valueOf(d * diff);
    dc = dc.setScale(1);
    str_dc = dc.toPlainString();
    BCAddTemperatureReading(shipmentid, str_dc, str_t_minus_30);

    d = Math.random();
    dc = Decimal.valueOf(bccontract.minTemperature__c)+Decimal.valueOf(d * diff);
    dc = dc.setScale(1);
    str_dc = dc.toPlainString();
    BCAddTemperatureReading(shipmentid, str_dc, str_t_minus_60);

    d = Math.random();
    dc = Decimal.valueOf(bccontract.minTemperature__c)+Decimal.valueOf(d * diff);
    dc = dc.setScale(1);
    str_dc = dc.toPlainString();
    BCAddTemperatureReading(shipmentid, str_dc, str_t_minus_90);

    d = Math.random();
    dc = Decimal.valueOf(bccontract.minTemperature__c)+Decimal.valueOf(d * diff);
    dc = dc.setScale(1);
    str_dc = dc.toPlainString();
    BCAddTemperatureReading(shipmentid, str_dc, str_t_minus_120);
} catch (Exception e) {
     throw e;

}*/

        return 'Done';


                }




@AuraEnabled
    public static String BCAddTemperatureReading(String shipmentid,String temperature,String timestamp) {

        //BCShipment__x shipment=[select ShipmentId__c,type__c,status__c,unitCount__c,contract__c from BCShipment__x where ShipmentId__c=:shipmentid limit 1];

        //shipment.status__c='ARRIVED';

        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(TEMPERATUREREADINGURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String body;
        body='{"$class": "org.acme.shipping.perishable.TemperatureReading"';
        body+=',';
        body+='"centigrade":"'+temperature+'"';
        body+=',';
        body+='"timestamp":"'+timestamp+'"';
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
        //throw new Exception('test');


    }

    @AuraEnabled
    public static String BCShipmentInTransit(String shipmentid) {

        BCShipment__x shipment=[select ShipmentId__c,type__c,status__c,unitCount__c,contract__c from BCShipment__x where ShipmentId__c=:shipmentid limit 1];

        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(SHIPMENTINTRANSITURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String body;
        body='{"$class": "org.acme.shipping.perishable.ShipmentInTransit"';
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
    public static String BCShipmentPacked(String shipmentid) {

        BCShipment__x shipment=[select ShipmentId__c,type__c,status__c,unitCount__c,contract__c from BCShipment__x where ShipmentId__c=:shipmentid limit 1];

        //shipment.status__c='ARRIVED';

        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(SHIPMENTPACKEDURL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String body;
        body='{"$class": "org.acme.shipping.perishable.ShipmentPacked"';
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



    @AuraEnabled
    public static String deleteTemperaturesOnShipment(String shipmentid) {


        BCShipment__x shipment=[select ShipmentId__c,type__c,status__c,unitCount__c,contract__c from BCShipment__x where ShipmentId__c=:shipmentid limit 1];

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
        req.setEndpoint(SHIPMENTURL+'/'+shipmentid);
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
        body+='"temperatureReadings":'+'[]';
        body+=',';
        body+='"contract":"resource:org.acme.shipping.perishable.Contract#'+shipment.contract__c+'"';
        body+='}';


        req.setBody(body);
        req.setMethod('PUT');
        res = h.send(req);

        if  (res.getStatusCode() == 200)
            return body;
        else
                //throw new AuraHandledException(res.getBody() );
return body;

    }




    
}