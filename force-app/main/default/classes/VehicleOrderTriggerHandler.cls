public class VehicleOrderTriggerHandler {

    public static void handleTrigger(
        List<Vehicle_Order__c> newOrders,
        Map<Id, Vehicle_Order__c> oldOrders,
        Boolean isBefore,
        Boolean isAfter,
        Boolean isInsert,
        Boolean isUpdate
    ) {

        if (isBefore && (isInsert || isUpdate)) {
            preventOrderIfOutOfStock(newOrders);
        }

        if (isAfter && (isInsert || isUpdate)) {
            updateStockOnOrderPlacement(newOrders, oldOrders);
        }
    }

    private static void preventOrderIfOutOfStock(
        List<Vehicle_Order__c> orders
    ) {

        Set<Id> vehicleIds = new Set<Id>();

        for (Vehicle_Order__c order : orders) {
            if (order.Vehicle__c != null) {
                vehicleIds.add(order.Vehicle__c);
            }
        }

        if (vehicleIds.isEmpty()) {
            return;
        }

        Map<Id, Vehicle__c> vehicleMap =
            new Map<Id, Vehicle__c>([
                SELECT Id, Stock_Quantity__c
                FROM Vehicle__c
                WHERE Id IN :vehicleIds
            ]);

        for (Vehicle_Order__c order : orders) {

            if (order.Vehicle__c == null) {
                continue;
            }

            Vehicle__c vehicle = vehicleMap.get(order.Vehicle__c);

            if (vehicle != null &&
                (vehicle.Stock_Quantity__c == null ||
                 vehicle.Stock_Quantity__c <= 0)) {

                order.addError(
                    'This vehicle is out of stock. Order cannot be placed.'
                );
            }
        }
    }

    private static void updateStockOnOrderPlacement(
        List<Vehicle_Order__c> orders,
        Map<Id, Vehicle_Order__c> oldOrders
    ) {

        Map<Id, Integer> vehicleQuantityMap = new Map<Id, Integer>();

        for (Vehicle_Order__c order : orders) {

            Boolean becameConfirmed =
                order.Status__c == 'Confirmed' &&
                (
                    oldOrders == null ||
                    !oldOrders.containsKey(order.Id) ||
                    oldOrders.get(order.Id).Status__c != 'Confirmed'
                );

            if (becameConfirmed && order.Vehicle__c != null) {

                if (!vehicleQuantityMap.containsKey(order.Vehicle__c)) {
                    vehicleQuantityMap.put(order.Vehicle__c, 0);
                }

                vehicleQuantityMap.put(
                    order.Vehicle__c,
                    vehicleQuantityMap.get(order.Vehicle__c) + 1
                );
            }
        }

        if (vehicleQuantityMap.isEmpty()) {
            return;
        }

        List<Vehicle__c> vehiclesToUpdate = new List<Vehicle__c>();

        for (Vehicle__c vehicle : [
            SELECT Id, Stock_Quantity__c
            FROM Vehicle__c
            WHERE Id IN :vehicleQuantityMap.keySet()
        ]) {

            Integer quantity =
                vehicleQuantityMap.get(vehicle.Id);

            Decimal currentStock =
                vehicle.Stock_Quantity__c == null
                ? 0
                : vehicle.Stock_Quantity__c;

            if (currentStock < quantity) {
                continue;
            }

            vehicle.Stock_Quantity__c =
                currentStock - quantity;

            if (vehicle.Stock_Quantity__c <= 0) {
                vehicle.Status__c = 'Out of Stock';
            }

            vehiclesToUpdate.add(vehicle);
        }

        if (!vehiclesToUpdate.isEmpty()) {
            update vehiclesToUpdate;
        }
    }
}