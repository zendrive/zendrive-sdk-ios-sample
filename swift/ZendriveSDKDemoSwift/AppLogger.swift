//
//  AppLogger.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 30/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//

import Foundation
import CocoaLumberjack
import Crashlytics

final class AppLogger {
    static var logsDirectory: String?
    class func initializeLogger() {
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 24*60*60
        fileLogger.logFileManager.maximumNumberOfLogFiles = 14
        DDLog.add(fileLogger, with: DDLogLevel.all)
        DDLog.add(DDTTYLogger.sharedInstance, with: DDLogLevel.all)
        AppLogger.logsDirectory = fileLogger.logFileManager.logsDirectory
    }

    class func logInfo(_ message: @autoclosure () -> String,
                       level: DDLogLevel = DDLogLevel.info,
                       context: Int = 0,
                       file: StaticString = #file,
                       line: UInt = #line,
                       tag: Any? = nil,
                       asynchronous async: Bool = asyncLoggingEnabled,
                       ddlog: DDLog = .sharedInstance ) {
        print(message())
        DDLogInfo(message(), level: level, context: context, tag: tag, asynchronous: async, ddlog: ddlog)
        #if !DEBUG
        CLSLogv("%@",getVaList([message()]))
        #endif
    }

    class func logWarn(_ message: @autoclosure () -> String,
                               level: DDLogLevel = DDLogLevel.warning,
                               context: Int = 0,
                               file: StaticString = #file,
                               function: StaticString = #function,
                               line: UInt = #line,
                               tag: Any? = nil,
                               asynchronous async: Bool = asyncLoggingEnabled,
                               ddlog: DDLog = .sharedInstance) {
        print(message())
        DDLogWarn(message(), level: level, context: context, tag: tag, asynchronous: async, ddlog: ddlog)
        #if !DEBUG
        CLSLogv("%@",getVaList([message()]))
        #endif
    }

    class func logDebug(_ message: @autoclosure () -> String,
                                level: DDLogLevel = DDLogLevel.debug,
                                context: Int = 0,
                                file: StaticString = #file,
                                function: StaticString = #function,
                                line: UInt = #line,
                                tag: Any? = nil,
                                asynchronous async: Bool = asyncLoggingEnabled,
                                ddlog: DDLog = .sharedInstance) {
        print(message())
        DDLogDebug(message(), level: level, context: context, tag: tag, asynchronous: async, ddlog: ddlog)
        #if !DEBUG
        CLSLogv("%@",getVaList([message()]))
        #endif
    }

    class func logVerbose(_ message: @autoclosure () -> String,
                                  level: DDLogLevel = DDLogLevel.verbose,
                                  context: Int = 0,
                                  file: StaticString = #file,
                                  function: StaticString = #function,
                                  line: UInt = #line,
                                  tag: Any? = nil,
                                  asynchronous async: Bool = asyncLoggingEnabled,
                                  ddlog: DDLog = .sharedInstance) {
        print(message())
        DDLogVerbose(message(), level: .verbose, context: context, tag: tag, asynchronous: async, ddlog: ddlog)
        #if !DEBUG
        CLSLogv("%@",getVaList([message()]))
        #endif
    }

    class func logError(_ message: @autoclosure () -> String,
                                level: DDLogLevel = DDLogLevel.error,
                                context: Int = 0,
                                file: StaticString = #file,
                                function: StaticString = #function,
                                line: UInt = #line,
                                tag: Any? = nil,
                                asynchronous async: Bool = asyncLoggingEnabled,
                                ddlog: DDLog = .sharedInstance) {
        print(message())
        DDLogError(message(), level: .error, context: context, tag: tag, asynchronous: async, ddlog: ddlog)
        #if !DEBUG
        CLSLogv("%@",getVaList([message()]))
        #endif

        let error : Error = NSError(domain: "com.zendrive.sampleAppSwift", code: errorCodeForCurrentCallStack(), userInfo: [NSLocalizedDescriptionKey : message()] )
        Crashlytics.sharedInstance().recordError(error)
    }

    class func errorCodeForCurrentCallStack() -> Int {
        return (Thread.callStackSymbols.map { (input) -> String in
            var output = input.components(separatedBy: " ").filter({ $0 != "" })
            output.remove(at: 2)
            return output.joined(separator: " ")
            }.description.hash)  % Int(INT_MAX)
    }
}
