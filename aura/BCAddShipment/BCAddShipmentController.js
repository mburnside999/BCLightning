({
    doInit: function(component, event) {


        console.log('in BCAddShipmentdoInit()');
        //component.set("v.newGrower.city__c",mycountry);
    },
    handleRecordUpdated: function(component, event, helper) {



        var unitCount = component.get("v.simpleRecord.Quantity");
        var shipmentId = component.get("v.recordId");
        var contractId=component.get("v.simpleRecord.F_contractid__c");
        var productCode=component.get("v.simpleRecord.F_productCode__c");

        //check if the shipment is in the BC

        helper.checkForShipment(component,shipmentId);



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


    },
    shipmentInTransit: function(component, event,helper) {

                var varShipmentID = component.get("v.shipmentInBlockChain.ExternalId");
                helper.inTransitShipment(component,varShipmentID);
                $A.get('e.force:refreshView').fire();

            //var selectedItem = event.currentTarget;
            //var varShipmentID = selectedItem.dataset.record;
            //helper.packedShipment(component,varShipmentID);
           // helper.fireMyShipmentEvent(component,event);
           // var action = component.get("c.findAll");
             //action.setCallback(this, function(a) {
                    //component.set("v.shipments", a.getReturnValue());
               // });
               // $A.enqueueAction(action);
        } ,

    shipmentPacked: function(component, event,helper) {


        var varShipmentID = component.get("v.shipmentInBlockChain.ExternalId");
        helper.packedShipment(component,varShipmentID);
        $A.get('e.force:refreshView').fire();
       // helper.fireMyShipmentEvent(component,event);
       // var action = component.get("c.findAll");
         //action.setCallback(this, function(a) {
                //component.set("v.shipments", a.getReturnValue());
           // });
           // $A.enqueueAction(action);
    },
    shipmentReceived: function(component, event,helper) {


            var varShipmentID = component.get("v.shipmentInBlockChain.ExternalId");
            helper.receivedShipment(component,varShipmentID);
            $A.get('e.force:refreshView').fire();
           // helper.fireMyShipmentEvent(component,event);
           // var action = component.get("c.findAll");
             //action.setCallback(this, function(a) {
                    //component.set("v.shipments", a.getReturnValue());
               // });
               // $A.enqueueAction(action);
        }


})