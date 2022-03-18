public class AutoConvertLeads
{	@invocableMethod
	Public static void LeadAssign(List<Id> LeadIds)
	{
		LeadStatus CLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
		List<Database LeadConvert> MassLeadConvert = new List<Database LeadConvert>();
		for(id currentlead: LeadIds){
			Database.LeadConvert Leadconvert = new Database.LeadConvert();
			Leadconvert.setLeadId(currentlead);
			Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
			//Leadconvert.setDoNotCreateOpportunity(TRUE);
			MassLeadConvert.add(Leadconvert);
		}
		if (!MassLeadConvert.isEmpty()) {
			List<Database.LeadConvertResult> Icr = Database.convertLead(MassLeadconvert);
			
		}
	}

}