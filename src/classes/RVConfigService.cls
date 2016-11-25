/**
* @description This class leverages the Config custom metadata type to return configuration options for the application.
*/
public class RVConfigService {
	/** Licensed User state value for testing */
	@TestVisible private static Boolean testLicensedUser = true;
	/** DebugInfoRecipientEmails value for testing */
	@TestVisible private static String testDebugInfoEmails;
	/** EmailDebugInfoLog value for testing */
	@TestVisible private static Boolean testEmailDebugInfoLog = false;
	/** DebugInfoMaxAge value for testing */
	@TestVisible private static Integer testDebugInfoMaxAge;
	/** DebugInfoMaxNum value for testing */
	@TestVisible private static Integer testDebugInfoMaxNum;
	/** Organization Id value for testing */
	@TestVisible private static String testOrgId;
	/** Organization Name value for testing */
	@TestVisible private static String testOrgName;
	/** Packaged Apex Class Name */
	private static final String PACKAGED_CLASS_NAME = 'RVConfigService';
	/** Obfuscated Body Text */
	private static final String OBFUSCATED_BODY_TEXT = '(hidden)';
	/** Author */
	private static final String AUTHOR_NAME = 'aMinds Solutions, LLC';
	/** Packaged Apex Class */
	private static final List<ApexClass> PACKAGED_CLASS = Database.query('SELECT Name, Body, NameSpacePrefix FROM ApexClass WHERE Name = \'' + PACKAGED_CLASS_NAME + '\' LIMIT 1');

	/** Default config options */
	private static Config Settings{
		get {
			// Use cached value, if any, unless in test context
			return (Settings != null && !Test.isRunningTest()) ? Settings : new Config();				
		}
	}

	/** Set of SObjects that should temporarily have their trigger logic bypassed */
	public static Set<Schema.sObjectType> bypassObjects = new Set<Schema.sObjectType>();

	/** Namespace Prefix */
	public static String namespacePrefix{
		get{ return Settings.AppNamespacePrefix; }
	}

	/** Namespace */
	public static String namespace{
		get{ return Settings.AppNamespace; }
	}

	/** Licensed User State */
	public static Boolean licensedUser{
		get{ return Settings.UserLicensed; }
	}

	/** Key Prefix by Object Map */
	public static Map<String, String> keyPrefixByObject{
		get{
			if (keyPrefixByObject != null){ return keyPrefixByObject; }
			buildSchemaMaps();
			return keyPrefixByObject;
		}
	}

	/** Object by Key Prefix Map */
	public static Map<String, String> objectByKeyPrefix{
		get{
			if (objectByKeyPrefix != null){ return objectByKeyPrefix; }
			buildSchemaMaps();
			return objectByKeyPrefix;			
		}
	}
	
	/** Email Recipients for DebugInfo */
	public static String debugInfoEmails{
		get{ return Settings.debugInfoEmailRecipients; }
	}

	/** DebugInfo Log Emailing state */
	public static Boolean emailDebugInfoEnabled{
		get{ return Settings.emailDebugInfo; }
	}
	
	/** Debug state */
	public static Boolean loggingEnabled{
		get{ return Settings.logging; }
	}
	
	/** Maximum age in days of DebugInfo records */
	public static Integer debugInfoMaxAge{
		get{ return Settings.debugInfoAgeMax; }
	} 
	
	/** Maximum number of DebugInfo records */
	public static Integer debugInfoMaxNum{
		get{ return Settings.debugInfoNumMax; }
	}

	/** Package Version Number */
	public static String packageVersion{
		get{
			return Settings.packageVersionNumber != null ? String.valueOf(Settings.packageVersionNumber) : '';
		}
	}

	/** Organization Id */
	public static String orgId{
		get{ return Settings.organizationId; }
	}

	/** Organization Name */
	public static String orgName{
		get{ return Settings.organizationName; }
	}

	/**
	* @description Builds Schema Map Static Variables
	*/
	private static void buildSchemaMaps() {
		
		RVConfigService.keyPrefixByObject = new Map<String, String>();
		RVConfigService.objectByKeyPrefix = new Map<String, String>();
		
		// Determine key prefix by object (and vice versa) mappings
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
	    
	    for(String sObj : gd.keySet()){
	        final Schema.DescribeSObjectResult sObjResult =  gd.get(sObj).getDescribe(); 
	        // Some objects (such as history objects) may return null key prefix
	        if (sObjResult.getKeyPrefix() != null){
	        	RVConfigService.keyPrefixByObject.put(sObjResult.getKeyPrefix(), sObjResult.getName().toLowerCase());
	        	RVConfigService.objectByKeyPrefix.put(sObjResult.getName().toLowerCase(), sObjResult.getKeyPrefix());		        
	        }
	    }
	}

	/**
	* @description Resets test setting values to their defaults
	*/
	@TestVisible private static void resetTestSettings(){
		testLicensedUser = true;
		testDebugInfoEmails = null;
		testEmailDebugInfoLog = false;
		testDebugInfoMaxAge = null;
		testDebugInfoMaxNum = null;
		testOrgId = null;
		testOrgName = null;
	}
	
	/**
	* @description Private inner class representing an org's default configuration
	*/
	private class Config {
		/** Default Config Settings */
		private RVConfig__mdt defaultSettings = Test.isRunningTest() ? null : [SELECT debugInfoRecipientEmails__c, emailDebugInfoLog__c, enableLogging__c, maxDebugInfoAge__c, maxDebugInfoRecords__c FROM RVConfig__mdt WHERE DeveloperName = 'Default'];
		/** Namespace Prefix */
		private String appNamespacePrefix;
		/** Namespace */
		private String appNamespace;	
		/** Licensed User State */
		private Boolean userLicensed;
		/** Email Recipients for DebugInfo */
		private String debugInfoEmailRecipients;
		/** DebugInfo Log Emailing state */
		private Boolean emailDebugInfo;
		/** logging state */
		private Boolean logging;
		/** Maximum age in days of DebugInfo records */
		private Integer debugInfoAgeMax;
		/** Maximum number of DebugInfo records */
		private Integer debugInfoNumMax;
		/** Package Version */
		private Version packageVersionNumber;
		/** Organization Id */
		private String organizationId;
		/** Organization Name */
		private String organizationName;

		/**
		* @description Constructor method for Config inner class
		*/
		private Config() {
			this.debugInfoEmailRecipients = Test.isRunningTest() ? testDebugInfoEmails : defaultSettings.debugInfoRecipientEmails__c;
			this.emailDebugInfo = Test.isRunningTest() ? testEmailDebugInfoLog : defaultSettings.emailDebugInfoLog__c;
			this.logging = Test.isRunningTest() ? true : defaultSettings.enableLogging__c;
			this.debugInfoAgeMax = Test.isRunningTest() ? testDebugInfoMaxAge : (Integer)defaultSettings.maxDebugInfoAge__c;
			this.debugInfoNumMax = Test.isRunningTest() ? testDebugInfoMaxNum : (Integer)defaultSettings.maxDebugInfoRecords__c;
			this.organizationId = Test.isRunningTest() ? testOrgId : UserInfo.getOrganizationId();
			this.organizationName = Test.isRunningTest() ? testOrgName : UserInfo.getOrganizationName();			
			// Determine namespace
			this.appNamespacePrefix = '';
			
			for (ApexClass ac : PACKAGED_CLASS){
	            if (ac.Body == OBFUSCATED_BODY_TEXT || ac.Body.contains(AUTHOR_NAME)){
	                if (ac.nameSpacePrefix != null){
	                    // Namespace exists
	                    this.appNamespacePrefix = ac.nameSpacePrefix.toLowerCase();
	                    Boolean isManaged;
	                    try{
					        UserInfo.isCurrentUserLicensed(this.appNamespacePrefix);
					        isManaged = true;
					    }catch(System.TypeException e){
					        // Not in a managed namespace
					        isManaged = false;
					    }
	                    if (isManaged){
	                    	this.packageVersionNumber = System.requestVersion();
	                    }	                   
	                }
	            }
	        }
	        this.appNamespace = ( !String.isBlank(this.appNamespacePrefix) ) ? this.appNamespacePrefix + '__' : '';
	        // Determine if current user is licensed for namespace, if any
	        this.userLicensed = Test.isRunningTest() ? testLicensedUser : ( !String.isBlank(this.appNamespacePrefix) ) ? UserInfo.isCurrentUserLicensed(this.appNamespacePrefix) : true;	        		    
		}
	}
	
}