trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> tasksToCreate = new List<Task>();

    for (Opportunity opp : Trigger.New) {

        if (opp.StageName == 'Closed Won') {

            Task newTask = new Task(
                Subject = 'Follow Up Test Task',
                WhatId = opp.Id
            );

            tasksToCreate.add(newTask);
        }
    }

    if (!tasksToCreate.isEmpty()) {
        insert tasksToCreate;
    }
}