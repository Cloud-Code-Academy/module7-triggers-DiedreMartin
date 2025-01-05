trigger AccountTrigger on Account (before insert) {
        //account type to 'Prospect' if there is no value in the type
        if(Trigger.isBefore && Trigger.isInsert){
                accountType();
                accountBillingAddress();
                }    
        
        public static void accountType(){    
        for(Account acc : Trigger.NEW){
                if(String.isBlank(acc.type)){
        acc.type = 'Prospect';
        System.debug('Found acct record: ' +acc.type);
                }
        }  
        }}