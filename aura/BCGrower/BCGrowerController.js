({
    doInit : function(component, event) {
        
       console.log('in BCGrower doInit()');
        //var action = component.get("c.findAll");
        //action.setCallback(this, function(a) {
           // component.set("v.growers", a.getReturnValue());
       // });
       // $A.enqueueAction(action);
    },
     handleMyShipmentEvent : function(component, event) {
       console.log("BCGRowerController.js received shipmentevent");
        var searchKey=event.getParam("shipmentID");   
        var action = component.get("c.findGrowerByShipmentID");        
         action.setParams({
      "searchKey": searchKey
    });       
    action.setCallback(this, function(a) {
        console.log(a.getReturnValue());
        component.set("v.growers", a.getReturnValue());

    });
    $A.enqueueAction(action); 
    
    } 
 })