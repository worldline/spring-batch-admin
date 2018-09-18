<#import "/spring.ftl" as spring />
<#if jobInfo?? && jobInfo.jobInstanceId??>"jobInstance" : {
	"id" : ${jobInfo.jobInstanceId?c}, 
	"jobName" : "${jobInfo.name}",</#if>
	<#if jobExecutions?? && jobExecutions?size!=0>
	"jobExecutions" : {<#list jobExecutions as jobExecutionInfoWithComment><#assign url><@spring.url relativeUrl="${servletPath}/jobs/executions/${jobExecutionInfoWithComment.jobExecutionInfo.id?c}.json"/></#assign>
		"${jobExecutionInfoWithComment.jobExecutionInfo.id}" : {
			"status" : "${jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.status}",
			"startDate" : "${jobExecutionInfoWithComment.jobExecutionInfo.startDate}",
			"startTime" : "${jobExecutionInfoWithComment.jobExecutionInfo.startTime}",
			"duration" : "${jobExecutionInfoWithComment.jobExecutionInfo.duration}",
			"resource" : "${baseUrl}${url}",
			"comment" : "${jobExecutionInfoWithComment.comment.comment}",
			"jobParameters" : {<#assign params=jobExecutionInfoWithComment.jobExecutionInfo.jobParameters/><#list params?keys as param>
				"${param}" : "${params[param]}"<#if param_index != params?size-1>,</#if></#list>
			}
		}<#if jobExecutionInfoWithComment_index != jobExecutions?size-1>,</#if></#list>
	}<#if nextJobExecution?? || previousJobExecution??>,
	<#assign executions_url><@spring.url relativeUrl="${servletPath}/jobs/executions.json"/></#assign>
	"page" : {
		"start" : ${startJobExecution?c},
		"end" : ${endJobExecution?c},
		"total" : ${totalJobExecutions?c}<#if nextJobExecution??>, 
		"next" : "${baseUrl}${executions_url}?startJobExecution=${nextJobExecution?c}&pageSize=${pageSize!20}"</#if><#if previousJobExecution??>,
		"previous" : "${baseUrl}${executions_url}?startJobExecution=${previousJobExecution?c}&pageSize=${pageSize!20}"</#if>
	}
	</#if>
<#if jobInfo?? && jobInfo.jobInstanceId??>}</#if></#if>
