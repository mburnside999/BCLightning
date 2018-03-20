({
    handleClick : function(component, event) {
       console.log('in BCUtility deleteAll()');
        var action = component.get("c.deleteAll");
        action.setCallback(this, function(a) {
            console.log('in callback');
            $A.get('e.force:refreshView').fire();
       });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
             // make Spinner attribute true for display loading spinner
              component.set("v.Spinner", true);
         },

       // this function automatic call by aura:doneWaiting event
          hideSpinner : function(component,event,helper){
           // make Spinner attribute to false for hide loading spinner
             component.set("v.Spinner", false);
          }

 })




