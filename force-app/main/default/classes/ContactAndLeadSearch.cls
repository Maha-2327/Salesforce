public class ContactAndLeadSearch {

    public static List<List<SObject>> searchContactsAndLeads(String lastName) {

        List<List<SObject>> ContactLeadList = [
            FIND :lastName IN ALL FIELDS
            RETURNING
                Contact(Name),
                Lead(Name)
        ];

        return ContactLeadList;
    }
}