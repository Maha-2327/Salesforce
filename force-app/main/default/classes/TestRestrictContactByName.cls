@isTest
private class TestRestrictContactByName {

    static testMethod void metodoTest() {

        List<Contact> listContact = new List<Contact>();

        Contact c1 = new Contact(
            FirstName = 'Francesco',
            LastName = 'Riggio',
            Email = 'Test@test.com'
        );

        Contact c2 = new Contact(
            FirstName = 'Francesco1',
            LastName = 'INVALIDNAME',
            Email = 'Test@test.com'
        );

        listContact.add(c1);
        listContact.add(c2);

        Test.startTest();

        try {
            insert listContact;
        } catch (Exception ee) {
            System.debug('Exception: ' + ee.getMessage());
        }

        Test.stopTest();
    }
}