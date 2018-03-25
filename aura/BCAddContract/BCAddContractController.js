({
    doInit: function(component, event) {


        console.log('in BCAddContract doInit()');
        //component.set("v.newGrower.city__c",mycountry);
    },
    handleRecordUpdated: function(component, event) {


        var contractRecordId = component.get("v.simpleRecord.Id");
        var contractName = component.get("v.simpleRecord.Name");
        var contractImporter = component.get("v.simpleRecord.Importer__c");
        var contractGrower = component.get("v.simpleRecord.Grower__c");
        var contractShipper = component.get("v.simpleRecord.Shipper__c");
        var contractMinPenaltyFactor = component.get("v.simpleRecord.minPenaltyFactor__c");
        var contractMaxPenaltyFactor = component.get("v.simpleRecord.maxPenaltyFactor__c");
        var contractMinTemperature = component.get("v.simpleRecord.minTemperature__c");
        var contractMaxTemperature = component.get("v.simpleRecord.maxTemperature__c");
        var contractArrivalDateTime = component.get("v.simpleRecord.arrivalDateTime__c");
        var contractUnitPrice = component.get("v.simpleRecord.unitPrice__c");

        component.set("v.newContract.ExternalId", contractRecordId);
        component.set("v.newContract.arrivalDateTime__c", contractArrivalDateTime);
        component.set("v.newContract.unitPrice__c", contractUnitPrice);
        component.set("v.newContract.importer__c", contractImporter);
        component.set("v.newContract.grower__c", contractGrower);
        component.set("v.newContract.shipper__c", contractShipper);
        component.set("v.newContract.minTemperature__c", contractMinTemperature);
        component.set("v.newContract.maxTemperature__c", contractMaxTemperature);
        component.set("v.newContract.minPenaltyFactor__c", contractMinPenaltyFactor);
        component.set("v.newContract.maxPenaltyFactor__c", contractMaxPenaltyFactor);



    },

    clickCreate: function(component, event, helper) {

        // Create the new grower
        var newContract = component.get("v.newContract");
        console.log("Create contract: " + JSON.stringify(newContract));
        helper.createContract(component, newContract);

    }


})