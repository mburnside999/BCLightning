({
    doInit: function(component, event) {

        console.log('in BCIMporter doInit()');
        //component.set("v.newGrower.city__c",mycountry);
    },
    handleRecordUpdated: function(component, event) {

        var accountRecordId = component.get("v.simpleRecord.Id");
        var accountName = component.get("v.simpleRecord.Name");
        var accountBillingStreet = component.get("v.simpleRecord.BillingStreet");
        var accountBillingCity = component.get("v.simpleRecord.BillingCity");
        var accountBillingCountry = component.get("v.simpleRecord.BillingCountry");
        component.set("v.newImporter.accountPK__c", accountRecordId);

        component.set("v.newImporter.companyName__c", accountName);
        component.set("v.newImporter.street__c", accountBillingStreet);
        component.set("v.newImporter.city__c", accountBillingCity);
        component.set("v.newImporter.country__c", accountBillingCountry);

    },

    clickCreate: function(component, event, helper) {

        // Create the new importer
        var newImporter = component.get("v.newImporter");
        console.log("Create importer: " + JSON.stringify(newImporter));
        helper.createImporter(component, newImporter);

    }

})