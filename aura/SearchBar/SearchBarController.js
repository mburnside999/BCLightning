({
    searchKeyEvent: function(component, event, helper) {
        var myEvent = $A.get("e.c:SearchKeyEvent");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
    }
})