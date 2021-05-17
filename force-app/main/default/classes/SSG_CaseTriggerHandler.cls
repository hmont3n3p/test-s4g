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
public class SSG_CaseTriggerHandler extends TriggerHandler  {

public SSG_CaseTriggerHandler() {

}
public override void beforeUpdate() {

}
public override void  beforeInsert () {
	SSG_CaseServiceUtil.calculateEmailData((List<Case>) Trigger.new);
    SSG_CaseServiceUtil.lookupToPlanets((List<Case>) Trigger.new);
}
public override void  beforeDelete () {

}
public override void  afterInsert () {

}
public override void afterUpdate() {

}
public override void  afterDelete () {

}
public override void   afterUndelete  () {

}
}