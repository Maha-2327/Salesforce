@isTest
public class AddPrimaryContactTest {

    @testSetup
    static void setup() {

        List<Account> lstOfAcc = new List<Account>();

        for (Integer i = 1; i <= 100; i++) {

            if (i <= 50) {
                lstOfAcc.add(new Account(
                    Name = 'AC' + i,
                    BillingState = 'NY'
                ));
            } else {
                lstOfAcc.add(new Account(
                    Name = 'AC' + i,
                    BillingState = 'CA'
                ));
            }
        }

        insert lstOfAcc;
    }

    @isTest
    static void testAddPrimaryContact() {

        Contact con = new Contact(
            LastName = 'TestCont'
        );

        AddPrimaryContact addPCIns =
            new AddPrimaryContact(con, 'CA');

        Test.startTest();

        System.enqueueJob(addPCIns);

        Test.stopTest();

        System.assertEquals(
            50,
            [SELECT COUNT() FROM Contact WHERE LastName = 'TestCont']
        );
    }
}