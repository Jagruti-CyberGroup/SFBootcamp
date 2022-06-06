public class UpdateCampaignId {
//Code for Camapign Id
//
    public static void m1(){
    String s='Hi campiang is 7014x00000064DmAAI hehehe'; // Email Body as a Description
String c;  
System.debug('string is '+s);
List<String> lstAlpha = s.split(' ');     // List for storing the String values SPace Seprated

        System.debug(lstAlpha);
        
        for (integer j = 0;j < lstAlpha.size(); j++){   // Running For loop on List to get the required value
            if(lstAlpha[j].startsWith('701')){           // if list will contain any value starting with '701'
                 c = lstAlpha[j];                       // value will get assigned  to Campaign Id
            }
        }
System.debug(c);
}
}