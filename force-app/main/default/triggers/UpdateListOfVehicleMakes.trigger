trigger UpdateListOfVehicleMakes on Vehicle_Makes__c (after insert) {
    
    List<String> newMakes = new List<String>();
    for (Vehicle_Makes__c vm : Trigger.new) {
        newMakes.add(vm.Name);
    }


}