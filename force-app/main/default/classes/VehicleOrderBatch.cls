global class VehicleOrderBatch
    implements Database.Batchable<SObject> {

    global Database.QueryLocator start(
        Database.BatchableContext bc
    ) {

        return Database.getQueryLocator([
            SELECT Id,
                   Status__c,
                   Vehicle__c,
                   Vehicle__r.Stock_Quantity__c
            FROM Vehicle_Order__c
            WHERE Status__c = 'Pending'
            AND Vehicle__c != null
        ]);
    }

    global void execute(
        Database.BatchableContext bc,
        List<Vehicle_Order__c> orders
    ) {

        List<Vehicle_Order__c> ordersToUpdate =
            new List<Vehicle_Order__c>();

        for (Vehicle_Order__c order : orders) {

            if (order.Vehicle__r != null &&
                order.Vehicle__r.Stock_Quantity__c != null &&
                order.Vehicle__r.Stock_Quantity__c > 0) {

                order.Status__c = 'Confirmed';
                ordersToUpdate.add(order);
            }
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }

    global void finish(
        Database.BatchableContext bc
    ) {

        System.debug(
            'Vehicle Order Batch Processing Completed'
        );
    }
}