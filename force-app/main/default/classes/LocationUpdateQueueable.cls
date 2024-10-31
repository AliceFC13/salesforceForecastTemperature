public class LocationUpdateQueueable implements Queueable, Database.AllowsCallouts {
    private Id accountId;
    private Decimal latitude;
    private Decimal longitude;

    public LocationUpdateQueueable(Id accountId, Decimal latitude, Decimal longitude) {
        this.accountId = accountId;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public void execute(QueueableContext context) {
        // Obține numele țării pe baza latitudinii și longitudinii
        String countryName = SiteService.getLocationName(latitude, longitude);
        
        // Actualizează contul corespunzător
        Account accountToUpdate = [SELECT Id, Site FROM Account WHERE Id = :accountId LIMIT 1];
        accountToUpdate.Site = countryName;
        update accountToUpdate; // Salvează modificările
    }
}

