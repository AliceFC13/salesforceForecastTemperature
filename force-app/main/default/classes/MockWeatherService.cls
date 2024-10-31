public class MockWeatherService implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Creează un răspuns simulativ
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"status": "success", "daily": {"temperature_2m_max": [15, 16, 17], "temperature_2m_min": [10, 11, 12]}}');
        return res;
    }
}