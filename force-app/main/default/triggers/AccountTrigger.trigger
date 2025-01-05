trigger AccountTrigger on Account (before insert, after insert) {
//account type to 'Prospect' if there is no value in the type
    if(Trigger.isBefore && Trigger.isInsert){
        accountType();
        accountBillingAddress();
        accountRatingHot();
        }    
    

public static void accountType(){    
    for(Account acc : Trigger.NEW){
        if(String.isBlank(acc.type)){
            acc.type = 'Prospect';
            }
        }  
    }

public static void accountBillingAddress(){
    for (Account accAdd : Trigger.NEW){
        if(accAdd.ShippingAddress == null) {
            accAdd.BillingStreet = accAdd.ShippingStreet;
            accAdd.BillingCity = accAdd.ShippingCity;
            accAdd.BillingState = accAdd.ShippingState;
            accAdd.BillingPostalCode = accAdd.ShippingPostalCode;
            accAdd.BillingCountry = accAdd.ShippingCountry;
        }
    }   
}
public static void accountRatingHot(){
    //account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value
    for(Account accRate : Trigger.NEW){
        if(accRate.Phone != null && accRate.website != null && accRate.Fax != null){
            accRate.Rating = 'Hot';
        }
    }

}

if(Trigger.isAfter && Trigger.isInsert){
    //an account is inserted create a contact related to the account with the following default values:
    List<Contact> newContacts = new List<Contact>();
    for(Account accNew : Trigger.NEW){
        Contact eachContact = new Contact(LastName = 'DefaultContact',Email = 'default@email.com', AccountId = accNew.Id);
            newContacts.add(eachContact);
}
    database.insert(newContacts, AccessLevel.USER_MODE);
} 


} 

