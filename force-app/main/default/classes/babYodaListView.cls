public class babYodaListView {
@AuraEnabled(cacheable=true)
public static DataTableResponse getAllCases() {
	DataTableResponse dtr = new DataTableResponse();
	DataTableResponse response = new DataTableResponse();
	DataTableColumns datacolumns = null;
	List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
	datacolumns = new DataTableColumns( 'Asunto', 'Subject', 'text',50, true);
	lstDataColumns.add(datacolumns);
	datacolumns = new DataTableColumns( 'Estado', 'Status', 'picklist', 50, true);
	lstDataColumns.add(datacolumns);
	datacolumns = new DataTableColumns( 'Email de contacto', 'ContactEmail', 'email', 50, true);
	lstDataColumns.add(datacolumns);
	datacolumns = new DataTableColumns( 'Contacto relacionado', 'Contact_URL__c', 'url', 50, true);
	lstDataColumns.add(datacolumns);
	datacolumns = new DataTableColumns( 'Actions', 'action', 'action', 100, false );
	TypeAttributes dta = null;
	RowActions ra = new RowActions('Scanear','show_details');
	List<RowActions> list_ra = new List<RowActions>();
	list_ra.add(ra);
	TypeAttributes dtype = new TypeAttributes(list_ra);
	datacolumns.typeAttributes = dtype;
	lstDataColumns.add(datacolumns);
	dtr.lstDataTableData = [SELECT Subject,Status,ContactEmail,Contact_URL__c,Description FROM Case WHERE isClosed=false ORDER BY CreatedDate DESC LIMIT 5];
	dtr.lstDataTableColumns = lstDataColumns;
	dtr.optionList = getPicklistOptions();
	return dtr;
}

public class DataTableResponse {
@AuraEnabled
public List<DataTableColumns> lstDataTableColumns {get; set;}
@AuraEnabled
public List<sObject> lstDataTableData {get; set;}
@AuraEnabled
public List<SelectOptionObj> optionList {get; set;}

public DataTableResponse(){
	lstDataTableColumns = new List<DataTableColumns>();
	lstDataTableData = new List<sObject>();
}
}

public class DataTableColumns {
@AuraEnabled
public String label {get; set;}
@AuraEnabled
public String fieldName {get; set;}
@AuraEnabled
public String type {get; set;}
@AuraEnabled
public boolean sortable {get; set;}
@AuraEnabled
public TypeAttributes typeAttributes {get; set;}
@AuraEnabled
public Integer minColumnWidth {get; set;}

public DataTableColumns(String label, String fieldName, String type, Integer minColumnWidth, Boolean sortable){
	this.label = label;
	this.fieldName = fieldName;
	this.type = type;
	this.sortable = sortable;
	this.minColumnWidth = minColumnWidth;
}

public void setDataAttributes(TypeAttributes atts) {
	this.typeAttributes = atts;
}
}

public class RowActions {
@AuraEnabled
public String label {get; set;}
@AuraEnabled
public String name {get; set;}

public RowActions(String label, String name){
	this.label = label;
	this.name = name;
}
}

public class TypeAttributes {
@AuraEnabled
public List<RowActions> rowActions {get; set;}

public TypeAttributes(List<RowActions> rowActions){
	this.rowActions = rowActions;
}
}

@AuraEnabled
public static List<SelectOptionObj> getPicklistOptions() {
	List<SelectOptionObj> picklistOptions = new List<SelectOptionObj>();
	try {
		Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		SelectOptionObj option = null;
		for (Schema.PicklistEntry pickListVal : ple) {
			option = new SelectOptionObj(pickListVal.getLabel(), pickListVal.getValue(), pickListVal.isDefaultValue());
			picklistOptions.add(option);
		}

	} catch (Exception ex) {
		throw new AuraHandledException(ex.getMessage());
	}
	return picklistOptions;
}
public class SelectOptionObj {
@AuraEnabled
public String label { get; set; }
@AuraEnabled
public String value { get; set; }
@AuraEnabled
public Boolean isDefault {get; set;}

public SelectOptionObj(String label, String val,Boolean isDefault) {
	this.label = label;
	this.value = val;
	this.isDefault = isDefault;
}
}

@AuraEnabled
public static String callOut(String code,String idCase){	
	return SSG_Integration_BasicAuthRestCallout.callOut(code,'true',idCase);
}
}