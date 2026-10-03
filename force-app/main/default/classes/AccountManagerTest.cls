@isTest
private class AccountManagerTest {

    @isTest
    private static void getAccountTest1() {

        Id recordId = createTestRecord();

        // Set up a test request
        RestRequest request = new RestRequest();

        request.requestUri =
            '/services/apexrest/Accounts/' + recordId + '/contacts';

        request.httpMethod = 'GET';

        RestContext.request = request;

        // Call the method to test
        Account thisAccount = AccountManager.getAccount();

        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals('Test record', thisAccount.Name);
        System.assertEquals(1, thisAccount.Contacts.size());
        System.assertEquals('Test', thisAccount.Contacts[0].LastName);
    }

    // Helper method
    static Id createTestRecord() {

        // Create test Account
        Account testAcc = new Account(
            Name = 'Test record'
        );
        insert testAcc;

        // Create test Contact
        Contact testCon = new Contact(
            LastName = 'Test',
            AccountId = testAcc.Id
        );
        insert testCon;

        return testAcc.Id;
    }
}