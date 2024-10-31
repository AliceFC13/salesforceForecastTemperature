public class MockWeatherServiceError implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Creează un răspuns de eroare simulativ
        HttpResponse res = new HttpResponse();
        res.setStatusCode(404);
        res.setBody('{"error": "Not found"}');
        return res;
    }
}