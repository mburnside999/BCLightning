({
    doInit: function(component, event) {

        console.log('in BCShipper doInit()');
        //component.set("v.newShiper.city__c",mycountry);
    },
    handleRecordUpdated: function(component, event,helper) {

        var accountRecordId = component.get("v.simpleRecord.Id");
        var accountName = component.get("v.simpleRecord.Name");
        var accountBillingStreet = component.get("v.simpleRecord.BillingStreet");
        var accountBillingCity = component.get("v.simpleRecord.BillingCity");
        var accountBillingCountry = component.get("v.simpleRecord.BillingCountry");
        component.set("v.newShipper.accountPK__c", accountRecordId);
        component.set("v.newShipper.companyName__c", accountName);

        component.set("v.newShipper.companyName__c", accountName);
        component.set("v.newShipper.street__c", accountBillingStreet);
        component.set("v.newShipper.city__c", accountBillingCity);
        component.set("v.newShipper.country__c", accountBillingCountry);

    },

    clickCreate: function(component, event, helper) {

        // Create the new shipper
        var newShipper = component.get("v.newShipper");
        console.log("Create shipper: " + JSON.stringify(newShipper));
        helper.createShipper(component, newShipper);

    }


})