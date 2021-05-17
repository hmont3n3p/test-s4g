public class SSG_Integration_BasicAuthRestCallout {

public static String callOut(string resource, string keyToVerify,String idCase){

	String outcomeMsg; System.debug('******HM1******');

	string endpoint = 'https://s4g-mandalorian-server.herokuapp.com/scan/';
	string username = 'mando';
	string password = '12345';
	string method = 'GET';

	if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
		outcomeMsg = 'Se alcanzó el número máximo callouts permitidos.';


	} else if (endpoint == null || username == null || password == null) {
		outcomeMsg = 'Verifique sus credenciales de API';

	} else {


		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http h = new Http();

		req.setEndpoint(endpoint + resource);
		req.setMethod(method);
		req.setTimeout(120000);
		Blob headerValue = Blob.valueOf(username + ':' + password);
		String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
		req.setHeader('Authorization', authorizationHeader);
		req.setHeader('Accept', 'application/json');
		req.setHeader('Content-Type', 'application/json');
		try {
			res = h.send(req);
			if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
				Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
				if(untypedMap.containsKey(keyToVerify)) {
					outcomeMsg = 'Success!';
					Case caseObj=[Select id from Case Where Id =:idCase LIMIT 1][0];
					caseObj.Status='Closed';
					update caseObj;

				} else {
					outcomeMsg = 'Error: Verifique que la clave no se encuentre en la respuesta';
				}
			} else {
				Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
				outcomeMsg = 'Warning:'+untypedMap.get('error');
			}

		} catch (exception e) {

			outcomeMsg = 'Error: se ha encontrado una excepción al llamar a Integración:  ' + e.getMessage();
		}
	}


	return outcomeMsg;

}
}