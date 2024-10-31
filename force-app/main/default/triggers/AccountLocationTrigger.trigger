trigger AccountLocationTrigger on Account (before insert, before update) {
    AccountService.processLocationUpdates(Trigger.new);
}


