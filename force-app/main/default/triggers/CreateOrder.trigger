trigger CreateOrder on Spare_Parts__c (after insert) {
    
    List<Order> willCreatedOrder=new List<Order>();
    
    for(Spare_Parts__c spares : Trigger.new ){
        if(!spares.Available__c)  {
            System.debug('Creating order for Spare Parts record: ' + spares.Id);
            Order newOrder = new Order();
        	newOrder.Spare_Parts__c = spares.Id;
        	newOrder.Status = 'Draft';
        	newOrder.Work_Order__c = spares.Work_Order__c;
        	newOrder.AccountId = spares.AccountId__c;
    		newOrder.EffectiveDate=Date.today();
            willCreatedOrder.add(newOrder);
        }
    }
        System.debug('Inserting orders: ' + willCreatedOrder);

        if (willCreatedOrder.size() > 0) {
        insert willCreatedOrder;       
    } 
}