public class ContactSearch {

    public static List<Contact> searchForContacts(String lastName, String maillingpostalCode) {

        List<Contact> contactList = [
            SELECT Id, Name
            FROM Contact
            WHERE LastName = :lastName
            AND MailingPostalCode = :maillingpostalCode
        ];

        return contactList;
    }
}