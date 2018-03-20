public class BCUtility {

    private static String CONTRACTURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Contract';
    private static String GROWERURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Grower';
    private static String SHIPPERURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipper';
    private static String IMPORTERURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Importer';
    private static String SHIPMENTURL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment';

    @AuraEnabled
    public static String deleteAll() {
        //return [SELECT ExternalId, grower__c,shipper__c,importer__c,unitPrice__c,minTemperature__c,maxTemperature__c,minPenaltyFactor__c,maxPenaltyFactor__c,arrivalDateTime__c from BCContract2__x];

        List<String> myList=new List<String>();

        for (BCShipment__x bc: [select shipmentId__c from BCShipment__x]) {
            myList.add(bc.shipmentId__c);
        }
        purgeBC(myList,SHIPMENTURL);


        myList.clear();
        for (BCContract2__x bc: [select contractId__c from BCContract2__x]) {
            myList.add(bc.contractId__c);
        }
        purgeBC(myList,CONTRACTURL);

        myList.clear();
        for (BCGrower__x bc: [select accountPK__c from BCGrower__x]) {
            myList.add(bc.accountPk__c);
        }
        purgeBC(myList,GROWERURL);

        myList.clear();
        for (BCImporter__x bc: [select accountPK__c from BCImporter__x]) {
            myList.add(bc.accountPk__c);
        }
        purgeBC(myList,IMPORTERURL);

        myList.clear();
        for (BCShipper__x bc: [select accountPK__c from BCShipper__x]) {
            myList.add(bc.accountPk__c);
        }
        purgeBC(myList,SHIPPERURL);

        return 'Done';

    }


    @AuraEnabled
    public static void purgeBC(List<String> ids,String url) {


        Http h = new Http();
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setMethod('DELETE');

        for (String id : ids) {
            req.setEndpoint(url+'/'+id);
            res = h.send(req);
            System.debug(res.getBody());
        }


    }


}