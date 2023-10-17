/******************************************************************************************************
* copyright © 2015
*
* File      : ValuePlusTrigger.trigger
*
* Purpose   :    This is a trigger that manages all "triggers" by calling classes to perform actions
*                normally performed by triggers.  Created to manage trigger flow/priority.
*
*
* Referred from:    None
*-----------------------------------------------------------------------------
*
*Release Date       Request#    Updated By          Description
*----------------------------------------------------------------------------------------------------------------------
*
*06/26/2015         R151733         Patrick Maxwell     Updated 7/17/15
*08/21/2015         R152410         Venkat Araveeti     Updated MyCase trigger to after update
*11/11/2016         R153028         Venkata Araveeti    Added Mycase Payments RR from Opportunity to Value+
*02/09/2016         R153224         Patrick Maxwell     Added Payments Adoption Case creation
*09/08/2017         R178719         Hunter Hamaker      Consolidated Website and Payments RoundRobin into Filter
*09/14/2018                         Luke Vang (Contractor)  Consolidated all value plus triggers 
*******************************************************************************************************/

trigger ValuePlusTrigger on ValuePlus__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
     new ValuePlusTriggerHandler().run();
}