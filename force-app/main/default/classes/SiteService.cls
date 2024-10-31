public with sharing class SiteService {
    @AuraEnabled(cacheable=true)
    public static String getLocationName(Decimal latitude, Decimal longitude) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String url = 'https://nominatim.openstreetmap.org/reverse?lat=' + latitude + '&lon=' + longitude + '&format=json';
        request.setEndpoint(url);
        request.setMethod('GET');
    
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> address = (Map<String, Object>) jsonResponse.get('address');
                
                // Returnează numele țării
                return (String) address.get('country'); 
            } else {
                throw new SiteServiceException('Error fetching location data: ' + response.getStatus());
            }
        } catch (Exception e) {
            throw new SiteServiceException('Error fetching location data: ' + e.getMessage());
        }
    }

    // Clasa de excepție personalizată
    public class SiteServiceException extends Exception {}
}


