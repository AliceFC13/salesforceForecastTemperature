public with sharing class WeatherService {
    private static final String WEATHER_API_URL = 'https://api.open-meteo.com/v1/forecast';

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getWeather(Decimal latitude, Decimal longitude) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        // Construiește URL-ul pentru cererea API
        String url = WEATHER_API_URL + '?latitude=' + latitude + '&longitude=' + longitude + '&daily=temperature_2m_max,temperature_2m_min';
        request.setEndpoint(url);
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);
            // Debug pentru răspuns
            System.debug('Response Body: ' + response.getBody());

            // Verifică statusul răspunsului
            if (response.getStatusCode() == 200) {
                // Deserializăm răspunsul JSON
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                // Extragem datele despre temperatură
                Map<String, Object> dailyData = (Map<String, Object>) jsonResponse.get('daily');
                List<Object> maxTemperatures = (List<Object>) dailyData.get('temperature_2m_max');
                List<Object> minTemperatures = (List<Object>) dailyData.get('temperature_2m_min');
                
                // Debug pentru datele despre temperatură
                System.debug('Temperaturi maxime: ' + maxTemperatures);
                System.debug('Temperaturi minime: ' + minTemperatures);

                return jsonResponse; // Poți returna întregul răspuns sau doar temperatura
            } else {
                // Aruncă o excepție cu detalii despre eroare
                throw new WeatherServiceException('Error fetching weather data: ' + response.getStatus() + ' - ' + response.getBody());
            }
        } catch (Exception e) {
            throw new WeatherServiceException('Error fetching weather data: ' + e.getMessage());
        }
    }

    // Clasa de excepție personalizată
    public class WeatherServiceException extends Exception {}
}











