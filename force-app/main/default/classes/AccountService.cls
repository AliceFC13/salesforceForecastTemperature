public with sharing class AccountService {
    public static void processLocationUpdates(List<Account> accounts) {
        // Colectează coordonatele din câmpul Location__c
        for (Account acc : accounts) {
            if (acc.Location__c != null) {
                String[] coords = acc.Location__c.split(',');
                if (coords.size() == 2) {
                    Decimal latitude = Decimal.valueOf(coords[0].trim());
                    Decimal longitude = Decimal.valueOf(coords[1].trim());
                    
                    // Adaugă un job în coada de procesare
                    System.enqueueJob(new LocationUpdateQueueable(acc.Id, latitude, longitude));
                }
            }
        }
    }
}




