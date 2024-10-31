@isTest
public class AccountLocationTriggerTest {
    @isTest
    static void testAccountLocationTrigger() {
        // Creează un cont cu un câmp Location__c populat
        Account testAccount = new Account(Name = 'Test Account', Location__c = '37.7749,-122.4194'); // Coordonate pentru San Francisco
        insert testAccount;

        // Verifică numărul de joburi queueable
        List<CronTrigger> cronJobsBefore = [SELECT Id FROM CronTrigger];
        System.assertEquals(1, cronJobsBefore.size(), 'Jobul Queueable ar trebui să fie adăugat.');

        // Actualizează contul și verifică actualizarea site-ului
        testAccount.Location__c = '34.0522,-118.2437'; // Coordonate pentru Los Angeles
        update testAccount;

        // Verifică numărul de joburi queueable după actualizare
        List<CronTrigger> cronJobsAfter = [SELECT Id FROM CronTrigger];
        System.assertEquals(2, cronJobsAfter.size(), 'Ar trebui să existe 2 joburi queueable după actualizare.');

        // Verifică că contul a fost actualizat corect
        Account updatedAccount = [SELECT Id, Site FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, updatedAccount.Site, 'Site-ul ar trebui să fie actualizat.');
    }
}
