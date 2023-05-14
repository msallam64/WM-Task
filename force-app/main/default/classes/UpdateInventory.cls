global class UpdateInventory {
    
    @InvocableMethod(label ='Update Method')
    public static void UpdateInventoryAction(List<String> ProductSKU) {
        String apiUrl = 'https://th-superbadge-apex.herokuapp.com/equipment';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            List<Object> equipmentList = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> equipmentToUpdate = new List<Product2>();
            List<String> existingEquipmentIds = new List<String>();
            Map<String, Product2> existingEquipmentMap = new Map<String, Product2>();
            
            for (Product2 existingEquipment : [SELECT Id, SKU__c FROM Product2 WHERE SKU__c IN :ProductSKU]) {
                existingEquipmentIds.add(existingEquipment.SKU__c);
                existingEquipmentMap.put(existingEquipment.SKU__c, existingEquipment);
            }
            
            for (Object equipment : equipmentList) {
                Map<String, Object> equipmentMap = (Map<String, Object>) equipment;
                String sku = (String) equipmentMap.get('sku');
                
                if (existingEquipmentIds.contains(sku)) {
                    Product2 eq = existingEquipmentMap.get(sku);
                    System.debug('EQ'+eq);
                    eq.Name = (String) equipmentMap.get('name');
                    eq.Price__c = (Decimal) equipmentMap.get('cost');
                    eq.Quantity__c = (Decimal) equipmentMap.get('quantity');
                    eq.maintenanceperiod__c = (Decimal) equipmentMap.get('maintenanceperiod');
                    eq.lifespan__c = (Decimal) equipmentMap.get('lifespan');
                    eq.replacement__c = (Boolean) equipmentMap.get('replacement');

                    equipmentToUpdate.add(eq);
                } else {
                    Product2 eq = new Product2();
                    eq.Name = (String) equipmentMap.get('name');
                    eq.API_id__c = (String) equipmentMap.get('_id');
                    eq.replacement__c = (Boolean) equipmentMap.get('replacement');
                    eq.SKU__c = (String) equipmentMap.get('sku');
                    eq.Price__c = (Decimal) equipmentMap.get('cost');
                    eq.Quantity__c = (Decimal) equipmentMap.get('quantity');
                    eq.maintenanceperiod__c = (Decimal) equipmentMap.get('maintenanceperiod');
                    eq.lifespan__c = (Decimal) equipmentMap.get('lifespan');
                    
                    equipmentToUpdate.add(eq);
                    existingEquipmentIds.add(eq.SKU__c);
                    existingEquipmentMap.put(eq.SKU__c, eq);
                }
            }
            
            if (!equipmentToUpdate.isEmpty()) {
                System.debug('Data'+equipmentToUpdate);
                upsert equipmentToUpdate SKU__c;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'API error: ' + response.getBody()));
        }
    }
}