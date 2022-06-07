public class AsyncExecutionExample implements Queueable {
    //This is a chnage made for feature 2
    public void execute(QueueableContext context) {
        Account a = new Account(Name='Acme',Phone='(415) 555-1212');
        insert a;        
    }
}