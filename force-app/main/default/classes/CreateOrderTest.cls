@isTest
private class CreateOrderTest {
    @isTest static void testCreateOrder() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        WorkOrder testWorkOrder = new WorkOrder(AccountId = testAccount.Id);
        insert testWorkOrder;
        Spare_Parts__c testSparePart = new Spare_Parts__c(Product__c = '01t8e0000012VktAAE', Work_Order__c= testWorkOrder.Id);
        insert testSparePart;

        Test.startTest();
        insert testSparePart;
        Test.stopTest();

        List<Order> createdOrders = [SELECT Id, Spare_Parts__c, Work_Order__c, AccountId, Status FROM Order WHERE Spare_Parts__c = :testSparePart.Id];
        System.assertEquals(1, createdOrders.size());
        System.assertEquals(testSparePart.Id, createdOrders[0].Spare_Parts__c);
        System.assertEquals(testWorkOrder.Id, createdOrders[0].Work_Order__c);
        System.assertEquals(testAccount.Id, createdOrders[0].AccountId);
        System.assertEquals('Draft', createdOrders[0].Status);
    }
}