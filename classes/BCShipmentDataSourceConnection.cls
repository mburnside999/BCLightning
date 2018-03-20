/**
 *   Extends the DataSource.Connection class to enable 
 *   Salesforce to sync the external system’s schema 
 *   and to handle queries and searches of the external data. 
 **/
global class BCShipmentDataSourceConnection extends
    DataSource.Connection {
    private DataSource.ConnectionParams connectionInfo;
    
    private Boolean singleton=false;
    
    /**
     *   Constructor for DriveDataSourceConnection.
     **/
    global BCShipmentDataSourceConnection(
        DataSource.ConnectionParams connectionInfo) {
        this.connectionInfo = connectionInfo;
            System.debug('in contructor 1.');
    }
    
    /**
     *   Called when an external object needs to get a list of 
     *   schema from the external data source, for example when 
     *   the administrator clicks “Validate and Sync” in the 
     *   user interface for the external data source.   
     **/
    override global List<DataSource.Table> sync() {
        System.debug('in tables 1.');
        List<DataSource.Table> tables =
            new List<DataSource.Table>();
        List<DataSource.Column> columns;
        columns = new List<DataSource.Column>();
        //columns.add(DataSource.Column.text('title', 255));
        columns.add(DataSource.Column.text('description',255));
        columns.add(DataSource.Column.text('createdDate',255));
        columns.add(DataSource.Column.text('modifiedDate',255));
        columns.add(DataSource.Column.url('selfLink'));
        columns.add(DataSource.Column.url('DisplayUrl'));
        columns.add(DataSource.Column.text('shipmentId'));
        columns.add(DataSource.Column.text('type'));
        columns.add(DataSource.Column.text('class'));
         columns.add(DataSource.Column.text('unitCount'));
        columns.add(DataSource.Column.text('status'));
        columns.add(DataSource.Column.text('ExternalId',255));
        columns.add(DataSource.Column.text('contract',255));
        tables.add(DataSource.Table.get('BCShipment','shipmentId',
            columns));
        return tables;
    }

    /**
     *   Called to query and get results from the external 
     *   system for SOQL queries, list views, and detail pages 
     *   for an external object that’s associated with the 
     *   external data source.
     *   
     *   The QueryContext argument represents the query to run 
     *   against a table in the external system.
     *   
     *   Returns a list of rows as the query results.
     **/
    override global DataSource.TableResult query(
        DataSource.QueryContext context) {
        System.debug('in query 1.');
            DataSource.Filter filter = context.tableSelection.filter;
        String url;
        if (filter != null) {
            String thisColumnName = filter.columnName;
            if (thisColumnName != null && 
                thisColumnName.equals('ExternalId')) {
                singleton=true;
                    url = 'http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment/'+filter.columnValue;
                System.debug('in query 2.');
                }
            else {
                //url = 'http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment?filter[where]['+filter.columnName+']='+filter.columnValue;
                url = 'http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment';
                singleton=false;

                System.debug('in query 3.');
            }
            } else {
           System.debug('in query 4.');
                singleton=false;
           url='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment';
        }

        /**
         * Filters, sorts, and applies limit and offset clauses.
         **/
        List<Map<String, Object>> rows = 
            DataSource.QueryUtils.process(context, getData(url));
        return DataSource.TableResult.get(true, null,
            context.tableSelection.tableSelected, rows);
    }

    /**
     *   Called to do a full text search and get results from
     *   the external system for SOSL queries and Salesforce
     *   global searches.
     *   
     *   The SearchContext argument represents the query to run 
     *   against a table in the external system.
     *   
     *   Returns results for each table that the SearchContext 
     *   requested to be searched.
     **/
    override global List<DataSource.TableResult> search(
        DataSource.SearchContext context) {
        System.debug('in search 1.');
            List<DataSource.TableResult> results =
            new List<DataSource.TableResult>();

        for (Integer i =0;i< context.tableSelections.size();i++) {
            System.debug('in search loop 2.');
            String entity = context.tableSelections[i].tableSelected;
            String url='http://cap-au-sg-prd-01.integration.ibmcloud.com:15189/api/Shipment?filter' +
              '[where][or][0][shipmentId]='+context.searchPhrase+
              '&filter[where][or][1][type]='+context.searchPhrase+
              '&filter[where][or][2][status]='+context.searchPhrase;
            
            
       
            //String url = 
                //'https://www.googleapis.com/drive/v2/files'+
                //'?q=fullText+contains+\''+context.searchPhrase+'\'';
            results.add(DataSource.TableResult.get(
                true, null, entity, getData(url)));
        }

        return results;
    }

    /**
     *   Helper method to parse the data.
     *   The url argument is the URL of the external system.
     *   Returns a list of rows from the external system.
     **/
    public List<Map<String, Object>> getData(String url) {
        System.debug('in getData 1.');
        System.debug('url= '+url);
        String response = getResponse(url);
        String myresponse;
        
        //Hyperledger returns slightly different JSON structure depending on the query 
        if (singleton) {
            myresponse='{"kind":"hyperledger","items":['+   response + ']}' ;
        } else {
             
            myresponse='{"kind":"hyperledger","items":'+   response + '}' ; 
        }
        
        
       System.debug('in getData 4.');

        List<Map<String, Object>> rows =
            new List<Map<String, Object>>();
        System.debug('in getData 5.');

        Map<String, Object> responseBodyMap = (Map<String, Object>)
            JSON.deserializeUntyped(myresponse);
        System.debug('in getData 6.');

        /**
         *   Checks errors.
         **/
        
        Map<String, Object> error =
            (Map<String, Object>)responseBodyMap.get('error');
        if (error!=null) {
            System.debug('Error encountered');
            List<Object> errorsList =
                (List<Object>)error.get('errors');
            Map<String, Object> errors =
                (Map<String, Object>)errorsList[0];
            String errorMessage = (String)errors.get('message');
            throw new DataSource.OAuthTokenExpiredException(errorMessage);
        }

        List<Object> fileItems=(List<Object>)responseBodyMap.get('items');
        if (fileItems != null) {
            for (Integer i=0; i < fileItems.size(); i++) {
                Map<String, Object> item = 
                    (Map<String, Object>)fileItems[i];
                rows.add(createRow(item));  
            }
        } else {
            rows.add(createRow(responseBodyMap));
        }

        return rows;
    }

    /**
     *   Helper method to populate the External ID and Display 
     *   URL fields on external object records based on the 'id' 
     *   value that’s sent by the external system.
     *   
     *   The Map<String, Object> item parameter maps to the data 
     *   that represents a row.
     *   
     *   Returns an updated map with the External ID and 
     *   Display URL values.
     **/
    public Map<String, Object> createRow( 
        Map<String, Object> item){
        System.debug('in createRow 1.');
        String fkstr;
            Map<String, Object> row = new Map<String, Object>();
        for ( String key : item.keySet() ) {
            if (key == 'shipmentId') {
                row.put('ExternalId', item.get(key));
                row.put('shipmentId', item.get(key));
            } else if (key=='$class'){
                row.put('class', item.get(key));
            
            } else if (key=='selfLink') {
                row.put(key, item.get(key));
                row.put('DisplayUrl', item.get(key));
            } 
            else if (key=='contract') {
                fkstr=(String)item.get(key);  
                row.put('contract',fkstr.split('#')[1]);
                
            } else {
                row.put(key, item.get(key));
            }
        }
        return row;
    }
    
    static String mockResponse = '{' +
      '  "kind": "drive#file",' +
      '  "id": "12345",' +
      '  "selfLink": "files/12345",' +
      '  "title": "Mock File",' +
      '  "mimeType": "application/text",' +
      '  "description": "Mock response that’s used during tests",' +
      '  "createdDate": "2016-04-20",' +
      '  "modifiedDate": "2016-04-20",' +
      '  "version": 1' +
      '}';
    
    /**
     *   Helper method to make the HTTP GET call.
     *   The url argument is the URL of the external system.
     *   Returns the response from the external system.
     **/
    public String getResponse(String url) {
        if (System.Test.isRunningTest()) {
          // Avoid callouts during tests. Return mock data instead.
          return mockResponse;
        } else {
          // Perform callouts for production (non-test) results.
          Http httpProtocol = new Http();
          HttpRequest request = new HttpRequest();
          request.setEndPoint(url);
          request.setMethod('GET');
          request.setHeader('Authorization', 'Bearer '+
              this.connectionInfo.oauthToken);
          HttpResponse response = httpProtocol.send(request);
          return response.getBody();
        }
    }
    }