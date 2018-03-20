({
    doInit : function(component, event) {
        var action = component.get("c.findAll");
        action.setCallback(this, function(a) {
            component.set("v.shipments", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    fireShipmentEvent : function(component, event, helper) {
        console.log('in ShipmentListcontoller.fireShipmentEvent()');
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

    var selectedItem = event.currentTarget;
    var varShipmentID = selectedItem.dataset.record;
    helper.updateShipment(component,varShipmentID);
    helper.fireMyShipmentEvent(component,event);
    var action = component.get("c.findAll");
     action.setCallback(this, function(a) {
            component.set("v.shipments", a.getReturnValue());
        });
        $A.enqueueAction(action);
}  
 })