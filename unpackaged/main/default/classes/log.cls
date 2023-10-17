public class log {

	// Usage:
	// log.info('PageContructorDebug', o, 'why is my object null?');
	// log.log('PageContructorDebug', o, 'why is my object null?');
	// log.warn('PageContructorDebug', o, 'why is my object null?');
	// log.error('PageContructorDebug', o, 'why is my object null?');
	//
	// For instance: log.info('PageContructorDebug', o, 'why is my object null?');
	// would result in a debug block that looks like this:
	// <previous log lines>
	//
	//
	// === INFO ======================================================================
	// --- PageConstructorDebug ------------------------------------------------------
	// String Representation of exception object:
	// <object data here>
	// Message is:
	// why is my object null?
	// === INFO ======================================================================
	//
	//
	// <Log Resumes>

	// Constants
	public static final String INFODELINIATOR  = '=== INFO ======================================================================';
	public static final String LOGDELINIATOR   = '### LOG #######################################################################';
	public static final String WARNDELINIATOR  = '%%% WARN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
	public static final String ERRORDELINIATOR = '@@@ ERROR @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
	public static final String TAGDELINIATOR   = '-------------------------------------------------------------------------------';

	/**
	 * Info level log line - convience method
	 * @param tag a quick and easy search string
	 * @param o   Exception Object
	 * @param msg Anything else you'd like to add.
	 */
	public static void info(String tag, Object o, String msg) {
		printlog(tag, INFODELINIATOR, o, msg);
	}

	/**
	 * Log level log line - convience method for standard level log information
	 * @param tag a quick and easy search string
	 * @param o   Exception Object
	 * @param msg Anything else you'd like to add
	 */
	public static void log(String tag, Object o, String msg) {
		printlog(tag, LOGDELINIATOR, o, msg);
	}

	/**
	 * Warning Level log line - convience method for warning level log info
	 * @param tag a quick and easy search string
	 * @param o   Exception Object
	 * @param msg Anything else you'd like to add
	 */
	public static void warn(String tag, Object o, String msg) {
		printlog(tag, WARNDELINIATOR, o, msg);
	}

	/**
	 * Error level log line - convience method for error logs
	 * @param tag a quick and easy search string
	 * @param o   Exception Object
	 * @param msg Anything else you'd like to add
	 */
	public static void error(String tag, Object o, String msg) {
		printlog(tag, ERRORDELINIATOR, o, msg);
	}

	/**
	 * Outputs a level-specific block of data to the apex logs.
	 * @param  tag         A searchable String
	 * @param  levelHeader Class constant string representing a demarcation line in the logs.
	 * @param  o           Exception Object
	 * @param  msg         Any text you'd like to add
	 */
	private static void printLog(String tag, String levelHeader, Object o, String msg) {
		if (levelHeader == null) {
			levelHeader = INFODELINIATOR;
		}

		String output = '\n\n' + levelHeader;

		if (tag != null) {
			tag = '--- ' + tag + ' ';
			Integer len = 80 - tag.length();
			output += '\n' + tag + TAGDELINIATOR.left(len);
		}

		if (o != null) {
			output += '\n String Representation of exception object: ';
			output += '\n ' + o;
		}

		if (msg != null) {
			output += '\n Message is: ';
			output += '\n ' + msg;
		}

		output += '\n' + levelHeader + '\n\n';

		system.debug(output);
	}

}