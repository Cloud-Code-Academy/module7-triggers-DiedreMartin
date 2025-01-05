trigger OpportunityTrigger on Opportunity (before update, before insert, before delete) {
    //Opp updated validate that the amount is greater than 5000
    if(Trigger.isBefore && Trigger.isUpdate){
        opptyAmountUpdate();
    }

public static void opptyAmountUpdate(){
    for(Opportunity opp : Trigger.NEW){
        if(opp.Amount < 5000){
            opp.addError('Opportunity amount must be greater than 5000');
        }
    }
}
if (Trigger.isBefore && Trigger.isDelete) {
    // Collect account IDs from the opportunities being deleted
    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : Trigger.old) {
        accountIds.add(opp.AccountId);
    }

    // Query the accounts to retrieve the Industry field
    Map<Id, Account> accountMap = new Map<Id, Account>(
        [SELECT Id, Industry FROM Account WHERE Id IN :accountIds]
    );

    for (Opportunity opp : Trigger.old) {
        Account relatedAccount = accountMap.get(opp.AccountId);
        if (relatedAccount != null && 
            relatedAccount.Industry == 'Banking' && 
            opp.StageName == 'Closed Won') {
            opp.addError('Cannot delete closed opportunity for a banking account that is won');
        }
    }
}

//When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
if(Trigger.isBefore && Trigger.isUpdate){
    // Collect account IDs from the opportunities being updated
    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : Trigger.New) {
        accountIds.add(opp.AccountId);
}

        // Query the Contacts with Title of CEO 
        List<Contact> contactList = [SELECT Id, Title, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO' WITH USER_MODE];
    
            // Create a Map of AccountId to Contact
            Map<Id, Contact> contactMap = new Map<Id, Contact>();
            for (Contact con : contactList) {
                contactMap.put(con.AccountId, con);
            }

                for (Opportunity opp : Trigger.New) {
                    Contact primaryContact = contactMap.get(opp.AccountId);
                    if (primaryContact != null) {
                        opp.Primary_Contact__c = primaryContact.Id;
                    
            }
        }
    }    
}    


