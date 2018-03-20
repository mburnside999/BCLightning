public class BlockChainControllerExt {

private Account account;

public String myname {get; set; }
public String debug {get; set;}

private final String GROWER_URL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Grower';

private final String IMPORTER_URL='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Importer';
    
    
    public BlockChainControllerExt(ApexPages.StandardController controller) {
this.account = (Account)controller.getRecord();
    }
    
    
 

public PageReference addImporter() {
      
    String body;
    body='{"$class": "org.acme.shipping.perishable.Importer","participantName":"'+account.name+'","accountid":"'+account.id+'","address": {"$class": "org.acme.shipping.perishable.Address","street":"'+account.billingstreet+'","zip":"'+account.billingpostalcode+'","country":"'+account.billingcountry+'","city":"'+account.billingcity+'"},"accountBalance": 1000}';
    
   callout(IMPORTER_URL,body);
       
    return null;
  }
  
  public PageReference addGrower() {
      
    String body;
    body='{"$class": "org.acme.shipping.perishable.Grower","participantName":"'+account.name+'","accountid":"'+account.id+'","address": {"$class": "org.acme.shipping.perishable.Address","street":"'+account.billingstreet+'","zip":"'+account.billingpostalcode+'","country":"'+account.billingcountry+'","city":"'+account.billingcity+'"},"accountBalance": 1000}';
    
   callout(GROWER_URL,body);
       
    return null;
  }
      
      
     public void callout(String url,String body) {
     
     String theClass;
     
     if (url==GROWER_URL) 
     theClass='org.acme.shipping.perishable.Grower';
    else if (url==IMPORTER_URL) theClass='org.acme.shipping.perishable.Importer';
    else theClass='Undefined Blockchain Class';
     
     
     
            // Instantiate a new http object
    Http h = new Http();

     // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    //body='{"fred",:account.name}';
    //body='{"$class":"'+theclass+'",:account: "'+account.id+'","address": {"$class": "org.acme.shipping.perishable.Address","city": "'+account.billingcity+'","country": "'+account.billingcountry+'"},"accountBalance": 1000}';
    //req.setBody('{"$class": "org.acme.shipping.perishable.Importer","participantName":"'+account.name+'","accountid":"'+account.id+'","address": {"$class": "org.acme.shipping.perishable.Address","street":"'+account.billingstreet+'","zip":"'+account.billingpostalcode+'","country":"'+account.billingcountry+'","city":"'+account.billingcity+'"},"accountBalance": 1000}');
    req.setBody(body);
    req.setMethod('POST');
    debug='REQUEST: '+req.toString();
    
   
        HttpResponse res = new HttpResponse();

try {
         res = h.send(req);
         account.blockchainclass__c=theClass;
         upsert account;
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            
        } 
        finally {
        debug+=' ...RESPONSE: '+res.toString();
        
        }
     
     
     
     } 
      
      
      
      
        
        
    }