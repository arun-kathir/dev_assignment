/*
 * string str = '50';
Integer inte = (Integer)JSON.deserialize(str,Integer.class);
system.debug('inte: ' + inte);

String JSONCon = '{"FirstName":"Arun","LastName":"Kathir","Mobile":"+6582358445"}';
Contact con = (Contact)JSON.deserialize(JSONCon, Contact.class);
system.debug('con: ' + con);

String tv = '{"model":"XYZ","color":"Black"}';
wrapTv wtv = (wrapTv)JSON.deserialize(tv, wrapTv.class);
system.debug('wtv: ' + wtv);

String tv = '{"model":"XYZ","color":"Black","Code":"1111"}';
wrapTv wtv = (wrapTv)JSON.deserialize(tv, wrapTv.class);
wrapTv wtvStrict = (wrapTv)JSON.deserializeStrict(tv, wrapTv.class);
system.debug('wtv: ' + wtv);

String tv = '{"model":"XYZ","color":"Black"}';
map<string,Object> wtv = (map<string,Object>)JSON.deserializeUntyped(tv);
system.debug('wtv: ' + wtv);
system.debug('wtv: ' + wtv.keySet());
system.debug('wtv: ' + wtv.values());
*/
public class wrapTv {
	public string model;
    public string color;
}