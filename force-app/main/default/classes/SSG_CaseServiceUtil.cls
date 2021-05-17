/*
   @description       :
   @author            : humberto.montenegro@genesys.cl
   @group             :
   @last modified on  : 10-22-2020
   @last modified by  : Humberto Montenegro href=< humberto.montenegro@genesys.cl>
   Modifications Log
   Ver   Date         Author                         Modification
   1.0   21-10-2020  humberto.montenegro@genesys.cl       Initial Version
 */
public class SSG_CaseServiceUtil {

public static void calculateEmailData(List<Case> lstCaseObj){
	for(Case caseObj : (List<Case>) lstCaseObj) {
		if(SSG_CaseServiceUtil.isValidMessage(caseObj)) {
			String newDescription=caseObj.Description.substringAfter(':').trim();
			caseObj.Description=newDescription;
			String newSubject=caseObj.Subject.substringAfter('-').trim();
			caseObj.Subject=newSubject;
		}
	}
}


private static Boolean isValidMessage(Case caseObj){
	String newDescription=caseObj.Description.substringAfter(':').trim();
	String newSubject=caseObj.Subject.substringAfter('-').trim();
	return newDescription!=null && newSubject!=null;
}

public static void lookupToPlanets(List<Case> lstCases){
	Schema.SObjectField external_id = Planet__c.Fields.Code__c;

	Map<String,String> mapNewPlanets=new Map<String,String>();
	List<Case> lstCasesToLookup =new List<Case> ();
	for(Case caseObj : (List<Case>) lstCases) {
		if(SSG_CaseServiceUtil.isValidMessage(caseObj)) {
			mapNewPlanets.put(caseObj.Description,caseObj.Subject);
			lstCasesToLookup.add(caseObj);
		}
	}
	Map<String,String> mapOldPlanets=new Map<String,String>();
	for(Planet__c planetObj:[SELECT Id,Code__c FROM Planet__c WHERE Code__c IN:mapNewPlanets.keySet()]) {
		mapOldPlanets.put(planetObj.Code__c, planetObj.Id);
	}
	List<Planet__c> lstNewPlanets=new List<Planet__c>();
	Map<String,String> mapMergedPlanets=new Map<String,String>();
	for(Case caseObj : (List<Case>) lstCasesToLookup) {
		if(mapOldPlanets.containsKey(caseObj.Description)) {
			String idLookup=mapOldPlanets.get(caseObj.Description);
			caseObj.Planet__c=idLookup;
		}
		else{
			Planet__c newPlanet= new Planet__c(Name=caseObj.Subject,Code__c=caseObj.Description);
			lstNewPlanets.add(newPlanet);
			mapMergedPlanets.put(newPlanet.Code__c,newPlanet.Name);
		}
	}
	Database.upsert(lstNewPlanets, external_id, true);
    Map<String,String> mapNewMergedPlanets=new Map<String,String>();
	for(Planet__c planetObj:[SELECT Id,Code__c FROM Planet__c WHERE Code__c IN:mapMergedPlanets.keySet()]) {
		mapNewMergedPlanets.put(planetObj.Code__c, planetObj.Id);
	}
	for(Case caseObj : (List<Case>) lstCasesToLookup) {
		if(caseObj.Planet__c==null) {
			if(mapNewMergedPlanets.containsKey(caseObj.Description)) {
				String idLookup=mapNewMergedPlanets.get(caseObj.Description);
				caseObj.Planet__c=idLookup;
			}
		}
	}

}


}