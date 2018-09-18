<#import "/spring.ftl" as spring />
<#if jobExecutionInfoWithComment??>
  <#assign url><@spring.url relativeUrl="${servletPath}/jobs/executions/${jobExecutionInfoWithComment.jobExecutionInfo.id?c}.json"/></#assign>
  "jobExecution" : {
    "resource" : "${baseUrl}${url}",
    "id" : "${jobExecutionInfoWithComment.jobExecutionInfo.id?c}",
    "name" : "${jobExecutionInfoWithComment.jobExecutionInfo.name}",
    "status" : "${jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.status}",
    "startDate" : "${jobExecutionInfoWithComment.jobExecutionInfo.startDate}",
    "startTime" : "${jobExecutionInfoWithComment.jobExecutionInfo.startTime}",
    "duration" : "${jobExecutionInfoWithComment.jobExecutionInfo.duration}",
    "exitCode" : "${jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.exitStatus.exitCode}",
    "comment" : "${jobExecutionInfoWithComment.comment.comment}",
    "exitDescription" : "${jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.exitStatus.exitDescription?replace('\t','\\t')?replace('\n','\\n')?replace('\r','')?replace('\"','\\"')}",
   <#assign url><@spring.url relativeUrl="${servletPath}/jobs/${jobExecutionInfoWithComment.jobExecutionInfo.name}/${jobExecutionInfoWithComment.jobExecutionInfo.jobId?c}.json"/></#assign>
   "jobInstance" : { "resource" : "${baseUrl}${url}" },
<#if stepExecutionInfos?? && stepExecutionInfos?size != 0>
    "stepExecutions" : {<#list stepExecutionInfos as execution>
        "${execution.name}" : {
       	    "status" : "${execution.status}",
       	    "exitCode" : "${execution.exitCode}",
	        <#if execution.status != "NONE">
       	    "id" : "${execution.stepExecution.id?c}",
          <#assign url><@spring.url relativeUrl="${servletPath}/jobs/executions/${jobExecutionInfoWithComment.jobExecutionInfo.id?c}/steps/${execution.id?c}.json"/></#assign>
	        "resource" : "${baseUrl}${url}",
	        </#if>
       	    "readCount" : "${execution.stepExecution.readCount}",
       	    "writeCount" : "${execution.stepExecution.writeCount}",
       	    "commitCount" : "${execution.stepExecution.commitCount}",
       	    "rollbackCount" : "${execution.stepExecution.rollbackCount}",
       	    "duration" : "${execution.duration}"
	    }<#if execution_index != stepExecutionInfos?size-1>,</#if></#list>
    }
<#else>
    "stepExecutions" : {<#list jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.stepExecutions as stepExecution>
     <#assign steps_url><@spring.url relativeUrl="${servletPath}/jobs/executions/${jobExecutionInfoWithComment.jobExecutionInfo.id?c}/steps/${stepExecution.id?c}.json"/></#assign>
        "${stepExecution.stepName}" : {
        	"resource" : "${baseUrl}${steps_url}",
        	"status" : "${stepExecution.status}",
 			"exitCode" : "${stepExecution.exitStatus.exitCode}"
        }<#if stepExecution_index != jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.stepExecutions?size-1>,</#if></#list>
    }
</#if>
  }
</#if>