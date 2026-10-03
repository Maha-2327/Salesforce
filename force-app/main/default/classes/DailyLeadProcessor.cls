public class DailyLeadProcessor implements Schedulable {

    public void execute(SchedulableContext sc) {

        List<Lead> leadObj = [
            SELECT Id, LeadSource
            FROM Lead
            WHERE LeadSource = null
            LIMIT 200
        ];

        for (Lead l : leadObj) {
            l.LeadSource = 'Dreamforce';
        }

        if (!leadObj.isEmpty()) {
            update leadObj;
        }
    }
}