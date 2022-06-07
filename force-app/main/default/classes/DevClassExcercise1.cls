public class DevClassExcercise1 {
    //This is second change to feature 2
    public Account linkAccountToContact(String accName, String confirstName, String conLastName){
        Account acc = new Account();
        acc.Name = accName;
        insert acc;
        
        
        Contact con = new Contact();
        con.FirstName = confirstName;
        con.LastName = conLastName;
        con.AccountId = acc.Id;
        insert con;
        
        return acc;
    }

}