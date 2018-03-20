public with sharing class BCTempReadingController {

    @AuraEnabled
    public static List<BCTempReading__x> findAll() {
        return [SELECT ExternalId, centigrade__c,timestamp__c,shipmentFK__c FROM BCTempReading__x LIMIT 50];
    }
    @AuraEnabled
    public static List<BCTempReading__x > findBySupplierID(String searchKey) { 
        return [SELECT ExternalId, centigrade__c,timestamp__c,shipmentFK__c from BCTempReading__x WHERE shipmentLU__r.ExternalId=:searchKey LIMIT 50];
    }
@AuraEnabled
    public static List<BCTempReading__x > findByName() { 
        return [SELECT ExternalId, centigrade__c,timestamp__c,shipmentFK__c from BCTempReading__x];
    }
    

}