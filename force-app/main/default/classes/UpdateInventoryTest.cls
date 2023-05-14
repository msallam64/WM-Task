@isTest
private class UpdateInventoryTest {
    
    @isTest
    static void testUpdateInventoryAction() {
        String apiResponse = '[{"_id":"1","name":"Equipment 1","sku":"SKU1","cost":100.0,"quantity":10.0,"maintenanceperiod":12.0,"lifespan":24.0,"replacement":false}]';
        
        Product2 product = new Product2(SKU__c = 'ssss', Name = 'Product 1');
        insert product;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(apiResponse, 200));
        
        List<String> productSKUs = new List<String>{'SKU0', 'SKU1', 'SKU2'};
        
        Test.startTest();
        UpdateInventory.UpdateInventoryAction(productSKUs);
        Test.stopTest();
        
        List<Product2> equipmentList = [SELECT Name, SKU__c, Price__c, Quantity__c, maintenanceperiod__c, lifespan__c, replacement__c FROM Product2];
        System.assertEquals(1, equipmentList.size());
        System.assertEquals('Equipment 1', equipmentList[0].Name);
        System.assertEquals('ssss', equipmentList[0].SKU__c);
        System.assertEquals(100, equipmentList[0].Price__c);
        System.assertEquals(10, equipmentList[0].Quantity__c);
        System.assertEquals(12, equipmentList[0].maintenanceperiod__c);
        System.assertEquals(24, equipmentList[0].lifespan__c);
        System.assertEquals(false, equipmentList[0].replacement__c);
    }
    
    private class MockHttpResponse implements HttpCalloutMock {
        String apiResponse;
        Integer statusCode;
        
        public MockHttpResponse(String apiResponse, Integer statusCode) {
            this.apiResponse = apiResponse;
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(apiResponse);
            res.setStatusCode(statusCode);
            return res;
        }
    }
}