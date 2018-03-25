({


    checkForShipment: function(component, shipment) {
    console.log('looking for shipment: '+shipment)
    var action = component.get("c.findByShipmentId");
            action.setParams({
                "shipment": shipment
            });

            action.setCallback(this, function(a) {
                          console.log("find by shipmentid returned");
                          console.log(JSON.stringify(a.getReturnValue()));
                          component.set("v.shipmentInBlockChain", a.getReturnValue());

                      });

    $A.enqueueAction(action);
    },
    packedShipment: function(component, varShipmentID) {
                var action = component.get("c.BCShipmentPacked");
                action.setParams({
                    "shipmentid": varShipmentID
                });

                //var shippers = component.get("v.shippers");

                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        // Alert the user with the value returned
                        // from the server
                        console.log('Sending to BCShipmentPacked');
                        console.log("SUCCESS - APEX return value :" + response.getReturnValue());

                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type": "success",
                            "mode": "sticky",
                            "message": "Successfully executed BlockChain SHIPMENT PACKED TX."
                        });
                        toastEvent.fire();



                        // You would typically fire a event here to trigger
                        // client-side notification that the server-side
                        // action is complete
                    } else if (state === "INCOMPLETE") {
                        // do something
                    } else if (state === "ERROR") {
                        console.log("ERROR - APEX return value :" + response.getReturnValue());
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {

                                var jsonparse = JSON.parse(errors[0].message);
                                var errorEvent = $A.get("e.force:showToast");
                                errorEvent.setParams({
                                    "title": "Blockchain Error!",
                                    "type": "error",
                                    "mode": "sticky",
                                    "message": jsonparse.error.message
                                });
                                errorEvent.fire();
                                console.log("Error message: " + jsonparse.error.message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                    //var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    //dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire();
                });

                $A.enqueueAction(action);
            },
            receivedShipment: function(component, varShipmentID) {
                            var action = component.get("c.BCShipmentReceived");
                            action.setParams({
                                "shipmentid": varShipmentID
                            });

                            //var shippers = component.get("v.shippers");

                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    // Alert the user with the value returned
                                    // from the server
                                    console.log('Sending to BCShipmentReceived');
                                    console.log("SUCCESS - APEX return value :" + response.getReturnValue());

                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Success!",
                                        "type": "success",
                                        "mode": "sticky",
                                        "message": "Successfully executed BlockChain SHIPMENT RECEIVED TX."
                                    });
                                    toastEvent.fire();



                                    // You would typically fire a event here to trigger
                                    // client-side notification that the server-side
                                    // action is complete
                                } else if (state === "INCOMPLETE") {
                                    // do something
                                } else if (state === "ERROR") {
                                    console.log("ERROR - APEX return value :" + response.getReturnValue());
                                    var errors = response.getError();
                                    if (errors) {
                                        if (errors[0] && errors[0].message) {

                                            var jsonparse = JSON.parse(errors[0].message);
                                            var errorEvent = $A.get("e.force:showToast");
                                            errorEvent.setParams({
                                                "title": "Blockchain Error!",
                                                "type": "error",
                                                "mode": "sticky",
                                                "message": jsonparse.error.message
                                            });
                                            errorEvent.fire();
                                            console.log("Error message: " + jsonparse.error.message);
                                        }
                                    } else {
                                        console.log("Unknown error");
                                    }
                                }
                                //var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                //dismissActionPanel.fire();
                                $A.get('e.force:refreshView').fire();
                            });

                            $A.enqueueAction(action);
                        },
            inTransitShipment: function(component, varShipmentID) {
                            var action = component.get("c.BCShipmentInTransit");
                            action.setParams({
                                "shipmentid": varShipmentID
                            });

                            //var shippers = component.get("v.shippers");

                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    // Alert the user with the value returned
                                    // from the server
                                    console.log('Sending to BCShipmentPacked');
                                    console.log("SUCCESS - APEX return value :" + response.getReturnValue());

                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Success!",
                                        "type": "success",
                                        "mode": "sticky",
                                        "message": "Successfully executed BlockChain SHIPMENT IN TRANSIT TX."
                                    });
                                    toastEvent.fire();



                                    // You would typically fire a event here to trigger
                                    // client-side notification that the server-side
                                    // action is complete
                                } else if (state === "INCOMPLETE") {
                                    // do something
                                } else if (state === "ERROR") {
                                    console.log("ERROR - APEX return value :" + response.getReturnValue());
                                    var errors = response.getError();
                                    if (errors) {
                                        if (errors[0] && errors[0].message) {

                                            var jsonparse = JSON.parse(errors[0].message);
                                            var errorEvent = $A.get("e.force:showToast");
                                            errorEvent.setParams({
                                                "title": "Blockchain Error!",
                                                "type": "error",
                                                "mode": "sticky",
                                                "message": jsonparse.error.message
                                            });
                                            errorEvent.fire();
                                            console.log("Error message: " + jsonparse.error.message);
                                        }
                                    } else {
                                        console.log("Unknown error");
                                    }
                                }
                                //var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                //dismissActionPanel.fire();
                                $A.get('e.force:refreshView').fire();
                            });

                            $A.enqueueAction(action);
                        },

    createShipment: function(component, shipment) {
        var action = component.get("c.saveShipment");
        action.setParams({
            "shipment": shipment
        });

        //var shippers = component.get("v.shippers");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned
                // from the server
                console.log("SUCCESS - APEX return value :" + response.getReturnValue());

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "mode": "sticky",
                    "message": "Successfully added a SHIPMENT account to The blockchain."
                });
                toastEvent.fire();

                // You would typically fire a event here to trigger
                // client-side notification that the server-side
                // action is complete
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                console.log("ERROR ");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var jsonparse=JSON.parse(errors[0].message);
                        var errorEvent = $A.get("e.force:showToast");
                        errorEvent.setParams({
                            "title": "Blockchain Error!",
                            "type": "error",
                            "mode": "sticky",
                            "message": jsonparse.error.message
                        });
                        errorEvent.fire();
                        console.log("Error message: "+jsonparse.error.message);

                    }
                } else {
                    console.log("Unknown error");
                }
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });

        $A.enqueueAction(action);
    }
})