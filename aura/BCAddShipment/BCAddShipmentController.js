({
    doInit: function(component, event) {

        console.log('in BCAddShipmentdoInit()');
        //component.set("v.newGrower.city__c",mycountry);
    },
    handleRecordUpdated: function(component, event) {

        var unitCount = component.get("v.simpleRecord.Quantity");
        var shipmentId = component.get("v.recordId");
        var contractId=component.get("v.simpleRecord.F_contractid__c");
        var productCode=component.get("v.simpleRecord.F_productCode__c");

        component.set("v.newShipment.shipmentId__c", shipmentId);
        component.set("v.newShipment.unitCount__c", unitCount.toString());
        component.set("v.newShipment.contract__c",contractId);
        component.set("v.newShipment.type__c",productCode);

    },

    clickCreate: function(component, event, helper) {

        // Create the new grower
        var newShipment = component.get("v.newShipment");
        console.log("Create shipment: " + JSON.stringify(newShipment));
        helper.createShipment(component, newShipment);


    }


})