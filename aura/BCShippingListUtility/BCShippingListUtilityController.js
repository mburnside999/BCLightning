({
    doInit: function(component, event) {
        console.log("in doInit");
        var action = component.get("c.findAll");
        action.setCallback(this, function(a) {
            component.set("v.shipments", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    showModal: function(component, event, helper) {
        document.getElementById("yourId").style.display = "block";
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        var varShipmentID = event.getSource().get("v.tabindex");
        component.set("v.shipmentId", varShipmentID)
    },

    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        component.set("v.isOpen", false);
    },
    generateShipmentTemperatures: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer
        // and set set the "isOpen" attribute to "False for close the model Box.
        console.log('in genrateShipmentTemperatures');
        var action = component.get("c.generateTemperatures");
        var shipmentid = component.get("v.shipmentId");
        component.set("v.result", "Working...");
        action.setParams({
            "shipmentid": shipmentid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue);
                //component.set("v.result", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Successfully added Temperature Readings to the Blockchain."
                });
                toastEvent.fire();
                component.set("v.isOpen", false);
            } else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "title": "Blockchain Error!",
                    "type": "error",
                    "mode": "sticky",
                    "message": "Error adding temperatures"
                });
                errorEvent.fire();
                component.set("v.isOpen", false);
            }

        });
        $A.enqueueAction(action);
    },
    deleteShipmentTemperatures: function(component, event, helper) {
            // Display alert message on the click on the "Like and Close" button from Model Footer
            // and set set the "isOpen" attribute to "False for close the model Box.
            console.log('in deleteShipmentTemperatures');
            var action = component.get("c.deleteTemperaturesOnShipment");
            var shipmentid = component.get("v.shipmentId");
            component.set("v.result", "Working...");
            action.setParams({
                "shipmentid": shipmentid
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log(response.getReturnValue);
                    //component.set("v.result", response.getReturnValue());
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Successfully deleted Temperature Readings from the Blockchain."
                    });
                    toastEvent.fire();
                    component.set("v.isOpen", false);
                } else {
                    var errorEvent = $A.get("e.force:showToast");
                    errorEvent.setParams({
                        "title": "Blockchain Error!",
                        "type": "error",
                        "mode": "sticky",
                        "message": "Error deleting temperatures"
                    });
                    errorEvent.fire();
                    component.set("v.isOpen", false);
                }

            });
            $A.enqueueAction(action);
        }
})