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
trigger SSG_CaseTrigger_trg on Case (before insert, before update) {
	new SSG_CaseTriggerHandler().run();
}