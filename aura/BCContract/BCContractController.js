({
    doInit : function(component, event) {

       console.log('in BCContract doInit()');
        //var action = component.get("c.findAll");
        //action.setCallback(this, function(a) {
          // component.set("v.contracts", a.getReturnValue());
       // });
       // $A.enqueueAction(action);
    },
     handleMyShipmentEvent : function(component, event) {
       console.log("BCContractController.js received shipmentevent");
        var searchKey=event.getParam("shipmentID");
        var action = component.get("c.findByShipmentID");
         action.setParams({
      "searchKey": searchKey
    });
    action.setCallback(this, function(a) {
        console.log(a.getReturnValue());
        component.set("v.contracts", a.getReturnValue());

    });
    $A.enqueueAction(action);

    }
 })