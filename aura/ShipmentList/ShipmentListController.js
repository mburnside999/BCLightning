({
    doInit : function(component, event) {
        console.log("in doInit");
        var action = component.get("c.findAll");
        action.setCallback(this, function(a) {
                  component.set("v.shipments", a.getReturnValue());
                });
                $A.enqueueAction(action);
    },
    fireShipmentEvent : function(component, event, helper) {
        console.log('in ShipmentListcontoller.fireShipmentEvent()');
        var varShipmentID=event.getSource().get("v.tabindex");
        helper.fireMyShipmentEvent(component,event);
    },
    searchKeyEvent: function(component, event) {
    var searchKey = event.getParam("searchKey");
    var action = component.get("c.findByName");
    action.setParams({
      "searchKey": searchKey
    });
    action.setCallback(this, function(a) {
        component.set("v.shipments", a.getReturnValue());
    });
    $A.enqueueAction(action);
}, 
    shipmentReceived: function(component, event,helper) {
    console.log("shipmentReceived "+ event.getSource().get("v.tabindex"));
    //var selectedItem = event.currentTarget;
    //var varShipmentID = selectedItem.dataset.record;
    var varShipmentID=event.getSource().get("v.tabindex");
    helper.receiveShipment(component,varShipmentID);
    helper.fireMyShipmentEvent(component,event);
    var action = component.get("c.findAll");
     action.setCallback(this, function(a) {
            component.set("v.shipments", a.getReturnValue());
        });
        $A.enqueueAction(action);
}  ,
shipmentPacked: function(component, event,helper) {

    console.log("shipmentPAcked "+ event.getSource().get("v.tabindex"));
    //var selectedItem = event.currentTarget;
    //var varShipmentID = selectedItem.dataset.record;
    var varShipmentID=event.getSource().get("v.tabindex");
    helper.packedShipment(component,varShipmentID);
    helper.fireMyShipmentEvent(component,event);
    var action = component.get("c.findAll");
     action.setCallback(this, function(a) {
            component.set("v.shipments", a.getReturnValue());
        });
        $A.enqueueAction(action);
}  ,
shipmentInTransit: function(component, event,helper) {

    //var selectedItem = event.currentTarget;
    //var varShipmentID = selectedItem.dataset.record;
    var varShipmentID=event.getSource().get("v.tabindex");
    helper.inTransitShipment(component,varShipmentID);
    helper.fireMyShipmentEvent(component,event);
    var action = component.get("c.findAll");
     action.setCallback(this, function(a) {
            component.set("v.shipments", a.getReturnValue());
        });
        $A.enqueueAction(action);
}
 })