global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {

    // Instance member to retain state across transactions
    global Integer recordsProcessed = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, LeadSource FROM Lead'
        );
    }

    global void execute(Database.BatchableContext bc, List<Lead> scope) {

        // Process each batch of records
        List<Lead> leads = new List<Lead>();

        for (Lead lead : scope) {
            lead.LeadSource = 'Dreamforce';

            // Increment the instance member counter
            recordsProcessed = recordsProcessed + 1;

            leads.add(lead);
        }

        update leads;
    }

    global void finish(Database.BatchableContext bc) {
        System.debug(
            recordsProcessed + ' records processed. Shazam!'
        );
    }
}