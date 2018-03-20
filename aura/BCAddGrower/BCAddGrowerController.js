({
    doInit: function(component, event) {

        console.log('in BCGrower doInit()');
        //component.set("v.newGrower.city__c",mycountry);
    },
    handleRecordUpdated: function(component, event) {

        var accountRecordId = component.get("v.simpleRecord.Id");
        var accountName = component.get("v.simpleRecord.Name");
        var accountBillingStreet = component.get("v.simpleRecord.BillingStreet");
        var accountBillingCity = component.get("v.simpleRecord.BillingCity");
        var accountBillingCountry = component.get("v.simpleRecord.BillingCountry");


        component.set("v.newGrower.companyName__c", accountName);
        component.set("v.newGrower.accountPK__c", accountRecordId);
        component.set("v.newGrower.street__c", accountBillingStreet);
        component.set("v.newGrower.city__c", accountBillingCity);
        component.set("v.newGrower.country__c", accountBillingCountry);

    },

    clickCreate: function(component, event, helper) {

        // Create the new grower
        var newGrower = component.get("v.newGrower");
        console.log("Create grower: " + JSON.stringify(newGrower));
        helper.createGrower(component, newGrower);

    }


})