@isTest
public class WeatherServiceTest {
    @isTest
    public static void testGetWeatherSuccess() {
        // Setează mock-ul pentru a simula un răspuns de vreme valid
        Test.setMock(HttpCalloutMock.class, new MockWeatherService());

        // Datele de test
        Decimal latitude = 37.7749; // Latitudine pentru San Francisco
        Decimal longitude = -122.4194; // Longitudine pentru San Francisco

        // Executăm metoda
        Test.startTest();
        Map<String, Object> result = WeatherService.getWeather(latitude, longitude);
        Test.stopTest();

        // Verificăm rezultatul general
        System.assertNotEquals(null, result, 'Răspunsul nu ar trebui să fie null.');
        System.assert(result.containsKey('daily'), 'Răspunsul ar trebui să conțină o cheie "daily".');

        // Verificăm dacă există date zilnice și dacă structura este corectă
        Map<String, Object> dailyData = (Map<String, Object>) result.get('daily');
        System.assertNotEquals(null, dailyData, 'Datele zilnice nu ar trebui să fie null.');
        
        System.assert(dailyData.containsKey('temperature_2m_max'), 'Datele zilnice ar trebui să conțină cheie "temperature_2m_max".');
        System.assert(dailyData.containsKey('temperature_2m_min'), 'Datele zilnice ar trebui să conțină cheie "temperature_2m_min".');

        // Verificăm că listele de temperaturi nu sunt goale
        List<Object> maxTemperatures = (List<Object>) dailyData.get('temperature_2m_max');
        List<Object> minTemperatures = (List<Object>) dailyData.get('temperature_2m_min');

        System.assert(!maxTemperatures.isEmpty(), 'Lista temperaturilor maxime nu ar trebui să fie goală.');
        System.assert(!minTemperatures.isEmpty(), 'Lista temperaturilor minime nu ar trebui să fie goală.');


    }
}
