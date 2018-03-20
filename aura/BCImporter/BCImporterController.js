({
    doInit : function(component, event) {
        
       console.log('in BCImporter doInit()');
        //var action = component.get("c.findAll");
        //action.setCallback(this, function(a) {
           // component.set("v.importers", a.getReturnValue());
       // });
       // $A.enqueueAction(action);
    },
     handleMyShipmentEvent : function(component, event) {
        console.log("BCIMporterController.js received shipmentevent");
        var searchKey=event.getParam("shipmentID");   
        var action = component.get("c.findImporterByShipmentID");        
         action.setParams({
      "searchKey": searchKey
    });       
    action.setCallback(this, function(a) {
        console.log(a.getReturnValue());
        component.set("v.importers", a.getReturnValue());

    });
    $A.enqueueAction(action); 
    
    } 
 })