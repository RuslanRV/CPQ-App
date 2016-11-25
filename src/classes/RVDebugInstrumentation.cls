/**
* @description This class implements logging for the application
*/
public class RVDebugInstrumentation {

	public class CustomException extends Exception{

		public String resolutionMsg { get; private set;}
		public String errorCode { get; private set;}

		public CustomException(final String msg, final String errCode, final String resMsg){
			this(msg);
			this.errorCode = errCode;
			this.resolutionMsg = resMsg == null ? '\nPlease contact your system administrator' : resMsg;
		}

		public CustomException(final String msg, final String errCode){
			this(msg);
			this.errorCode = errCode;
			this.resolutionMsg = '\nPlease contact your system administrator';
		}
	}

	/** Stores list of debug entries */
	private static List<DebugEntry> debugLog;
	/** Stores current stack level for push/pop functionality */
	private static Integer currentLevel = 0;
	/** Stores custom strack trace string */
	private static List<String> stackTrace = new List<String>();
	/** Stores exception trace for custom stack trace */
	@TestVisible private static String exceptionTrace = '';

	/**
	* @description Inner class that represents a debug entry
	*/
	private class DebugEntry{
		Integer level;
		String description;

		private DebugEntry(final String entrydescription){
			level = currentLevel;
			description = '[' + System.now().format('HH:mm:ss.SSS') + '] {' + UserInfo.getName() + '} ' + entrydescription;
		}
	}

	/** 
	* @description Should be called at the start of every function to increment and update the current execution context level.
	* @param String Function name
	*/
	public static void push(final String functionName){
		debug('Entering: ' + functionName);
		currentLevel += 1;
		stackTrace.add(functionName);
	}
	
	/** 
	* @description Adds new debug entry to the debug log (if debug is enabled)
	* @param String Debug string value
	*/
	public static void debug(final String debugString){
		
		if(!RVConfigService.loggingEnabled) return;
		
		if(debugLog == null){
			debugLog = new List<DebugEntry>();
		}

		debugLog.add(new DebugEntry(debugString));		
		System.Debug(LoggingLevel.Info, debugString);
	}
	
	/** 
	* @description Called prior to popAll to add exception info to debug log and object
	* @param CustomException Thrown exception
	*/
	public static void debugException(final CustomException ex){
		final String exceptionInfo = 'Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage() + ' stack: ' + ex.getStackTraceString();
		debug(exceptionInfo);
		
		String userMsg = ex.getMessage() + '\n' + ex.resolutionMsg;
	
		final DebugInfo__c dbg = new DebugInfo__c(DebugMessage__c = userMsg, DebugErrorCode__c = ex.errorCode, DebugData__c = currentLog());
		exceptionTrace = ' Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage();
		exceptionTrace += '\nError Code: ' + ex.errorCode;
		
		for(String st: stackTrace){
			exceptionTrace += ' | ' + st;
		}		
		exceptionTrace += ' |\n ';
		
		if(RVConfigService.loggingEnabled){
			try {
				RVDMLManager.insertAsSystem(dbg);
			}catch(Exception e){
				// Unable to insert debug info
			}
			if (RVConfigService.debugInfoMaxNum != null || RVConfigService.debugInfoMaxAge != null){
				checkDebugInfoLog();
			}
		}
		popAll();
	}


	/** 
	* @description Called prior to popAll to add exception info to debug log and object
	* @param Exception Thrown exception
	*/
	public static void debugException(final Exception ex, final String errorCode){
		final String exceptionInfo = 'Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage() + ' stack: ' + ex.getStackTraceString();
		debug(exceptionInfo);
		
		String userMsg = ex.getMessage() + '\nPlease contact your system administrator to fix the defect.';
	
		final DebugInfo__c dbg = new DebugInfo__c(DebugMessage__c = userMsg, DebugErrorCode__c = errorCode, DebugData__c = currentLog());
		exceptionTrace = ' Exception occurred line ' + ex.getLineNumber() + ' - ' + ex.getMessage();
		exceptionTrace += '\nError Code: ' + errorCode;
		
		for(String st: stackTrace){
			exceptionTrace += ' | ' + st;
		}		
		exceptionTrace += ' |\n ';
		
		if(RVConfigService.loggingEnabled){
			try {
				RVDMLManager.insertAsSystem(dbg);
			}catch(Exception e){
				// Unable to insert debug info
			}
			if (RVConfigService.debugInfoMaxNum != null || RVConfigService.debugInfoMaxAge != null){
				checkDebugInfoLog();
			}
		}
		popAll();
	}

	/**
	* @description Should be called on the exit of every function to decrement and update the current execution context level.
	*/
	public static void pop(){
		if(currentLevel > 0){ currentLevel -= 1; }
		if(currentLevel == 0 && debugLog != null){ System.Debug(LoggingLevel.Info, 'EOF Log---------\n' + currentLog()); }
		if(stackTrace.size() > 0){ stackTrace.remove(stackTrace.size() - 1); }
	}
	
	/**
	* @description Used for exception handling
	*/
	public static void popAll(){
		currentLevel = 0;
		pop();
	}

		/**
	* @description Returns - human readable message to end user
	* @return String Indented log of debug message
	*/
	public static String defaultMessage(){
		if(debugLog == null) return null;
		String spaces = '                                                                        ';
		String result = '';
		for(DebugEntry de: debugLog){
			Integer endindex = 3 * de.level;
			if(endindex >= spaces.length()){ 
				endindex = spaces.length() - 1; 
			}
			result += spaces.substring(0, endindex) + de.description + '\n';
		}
		return result;
	}
	
	/**
	* @description Returns multi-line string representation of debug log
	* @return String Indented log of debug entries
	*/
	public static String currentLog(){
		if(debugLog == null) return null;
		String spaces = '                                                                        ';
		String result = '';
		for(DebugEntry de: debugLog){
			Integer endindex = 3 * de.level;
			if(endindex >= spaces.length()){ 
				endindex = spaces.length()-1; 
			}
			result += spaces.substring(0,endindex) + de.description + '\n';
		}
		return result;
	}

	/**
	* @description Checks if DebugInfo log needs clearing
	*/
	private static void checkDebugInfoLog(){
		final List<DebugInfo__c> debugInfoLog = [SELECT Id, Name, CreatedDate, DebugData__c, DebugMessage__c, DebugErrorCode__c FROM DebugInfo__c ORDER BY CreatedDate ASC];
		if (!debugInfoLog.isEmpty() && RVConfigService.debugInfoMaxNum != null && debugInfoLog.size() >= RVConfigService.debugInfoMaxNum){
			clearDebugInfoLog(debugInfoLog);
		}else if (!debugInfoLog.isEmpty() && RVConfigService.debugInfoMaxAge != null && 
				  (debugInfoLog[0].CreatedDate <= System.now().addDays(-1 * RVConfigService.debugInfoMaxAge)) || Test.isRunningTest()){
			final List<DebugInfo__c> debugInfoToDelete = new List<DebugInfo__c>();
			final DateTime maxAge = System.now().addDays(-1 * RVConfigService.debugInfoMaxAge);
			for (DebugInfo__c di : debugInfoLog){
				if (di.CreatedDate <= maxAge)
					debugInfoToDelete.add(di);
			}
			clearDebugInfoLog(debugInfoToDelete);
		}
	}
	
	/**
	* @description Deletes DebugInfo log records
	* @param List A list of debug info records to be deleted
	*/
	private static void clearDebugInfoLog(final List<DebugInfo__c> expiredDebugInfoLog){
		if (RVConfigService.emailDebugInfoEnabled && RVConfigService.debugInfoEmails != null && RVConfigService.debugInfoEmails != ''){
			emailDebugInfoLog(expiredDebugInfoLog);
		}
		if (expiredDebugInfoLog.size() >0 ){
			try {
				RVDMLManager.deleteAsSystem(expiredDebugInfoLog);
				Database.emptyRecycleBin(expiredDebugInfoLog);
			}catch(Exception ex){
				// Unable to delete debug info log
			}
		}
	}

	/**
	* @description Emails DebugInfo log
	* @param List A list of debug info records to be emailed
	*/
	private static void emailDebugInfoLog(final List<DebugInfo__c> debugInfoLog){
		//Define email settings
        final Messaging.SingleEmailMessage debugInfoEmail = new Messaging.SingleEmailMessage();                   
        debugInfoEmail.setToAddresses(RVConfigService.debugInfoEmails.split(';'));
        debugInfoEmail.setSubject('DebugInfo Log for ' + UserInfo.getOrganizationName() + '(' + UserInfo.getOrganizationId() + ')');
        final String emailMessage = 'Attached is the DebugInfo log that was cleared for ' + UserInfo.getOrganizationName() + '(' + UserInfo.getOrganizationId() + ')';
        debugInfoEmail.setPlainTextBody(emailMessage);
        debugInfoEmail.setHtmlBody(emailMessage);
        
        //Generate attachment
        final String csvString = new DebugInfoLogAttachment().generate(debugInfoLog);
        final transient Blob csvAttachment = Blob.valueOf(csvString);
        final transient Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setBody(csvAttachment);
        efa.setContentType('text/csv');
        efa.setFileName(System.today().format() + '_' + UserInfo.getOrganizationName() + '_DebugInfoLog.csv');
        efa.setInline(false);
        debugInfoEmail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        //Send email
        if (!Test.isRunningTest()){
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] {debugInfoEmail});
        }
	}

	/**
	* @description Inner class that represents a custom debug log attachment
	*/
	private class DebugInfoLogAttachment {		
		/**
		* @description Converts a list of debug info records into a string
		* @param List A list of debug info records
		* @return String A string representation of the debug info log
		*/
		private String generate(final List<DebugInfo__c> diLog) {
	        String s = line(new String[] {
	                format('DebugInfo Entry'),
	                format('Created Date'),
	                format('Debug Message'),
	                format('Debug Error Code'),
	                format('Debug Data')
	                });
	        for (DebugInfo__c di : diLog) {
	            s += line(new String[] {
	                    format(di.Name),
	                    format(di.CreatedDate),
	                    format(di.DebugMessage__c),
	                    format(di.DebugErrorCode__c),
	                    format(di.DebugData__c)
	                    });
	        }
	        return s;
	    }

	    /**
		* @description Converts list of strings to single, comma-delimited string with a line break
		* @param List A list of strings
		* @return String A comma-delimited string with a line break
		*/
	    private String line(final String[] cells) {
	        return String.join(cells, ',') + '\n';
	    }

	    /**
		* @description Converts datetime to CSV-formatted string
		* @param DateTime Datetime value
		* @return String CSV-formatted representation of datetime value
		*/
	    private String format(final DateTime dt)    {
	        return dt != null ? '"' + dt.format().escapeCsv() + '"' : '""';
	    }

	    /**
		* @description Converts text value to CSV-formatted string
		* @param String Text value
		* @return String CSV-formatted representation of text value
		*/
	    private String format(final String s) {
	        return s != null ? '"' + s.escapeCsv() + '"' : '""';
	    }
	}
	
}