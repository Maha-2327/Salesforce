public class AccountProcessor {

    @future
    public static void countContacts(List<Id> accountIds) {

        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Id IN :accountIds
        ];

        List<Account> updatedAccounts = new List<Account>();

        for (Account account : accounts) {

            account.Number_of_Contacts__c = [
                SELECT COUNT()
                FROM Contact
                WHERE AccountId = :account.Id
            ];

            updatedAccounts.add(account);

            System.debug(
                'No Of Contacts = ' + account.Number_of_Contacts__c
            );
        }

        if (!updatedAccounts.isEmpty()) {
            update updatedAccounts;
        }
    }
}