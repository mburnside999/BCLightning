({
    doInit : function(component, event){
            if ("WebSocket" in window)
            {
               alert("WebSocket is supported by your Browser!");
               
               // Let us open a web socket
               var ws = new WebSocket("ws://cap-au-sg-prd-01.integration.ibmcloud.com:15189");
                
               ws.onopen = function()
               {
                  // Web Socket is connected, send data using send()
                  ws.send("Message to send");
                  alert("Message is sent...");
               };
                
               ws.onmessage = function (evt) 
               { 
                  var received_msg = evt.data;
                  alert(evt.data);
               };
                
               ws.onclose = function()
               { 
                  // websocket is closed.
                  alert("Connection is closed..."); 
               };
                    
               window.onbeforeunload = function(event) {
                  socket.close();
               };
            }
            
            else
            {
               // The browser doesn't support WebSocket
               alert("WebSocket NOT supported by your Browser!");
            }
         }
}
 )