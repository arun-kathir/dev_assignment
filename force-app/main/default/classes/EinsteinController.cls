public class EinsteinController {
    public String getAccessToken() {
        ContentVersion base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform_Dev_edition' ORDER BY Title LIMIT 1];
        String keyContents = base64Content.VersionData.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');

        JWT jwt = new JWT('RS256');
        jwt.pkcs8 = keyContents; 
        jwt.iss = 'developer.force.com';
        jwt.sub = 'karunkumar1988@gmail.com'; // Change this with your email which is used for einstein api setup
        jwt.aud = 'https://api.einstein.ai/v2/oauth2/token';
        jwt.exp = '3600';
        String access_token = JWTBearerFlow.getAccessToken('https://api.einstein.ai/v2/oauth2/token', jwt);
        system.debug('access_token: ' + access_token);
        return access_token;    
    }
}