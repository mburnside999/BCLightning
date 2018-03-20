({
    doInit : function(component, event) {
       console.log('in TempReading:doInit()');
       // var action = component.get("c.findAll");
        //action.setCallback(this, function(a) {
            //component.set("v.temperaturereadings", a.getReturnValue());
        //});
        //$A.enqueueAction(action);
    },
     handleMyShipmentEvent : function(component, event) {
        var searchKey=event.getParam("shipmentID");   
        var action = component.get("c.findBySupplierID");        
         action.setParams({
      "searchKey": searchKey
    });       
    action.setCallback(this, function(a) {
        component.set("v.temperaturereadings", a.getReturnValue());
    });
    $A.enqueueAction(action);         
    } 
 })