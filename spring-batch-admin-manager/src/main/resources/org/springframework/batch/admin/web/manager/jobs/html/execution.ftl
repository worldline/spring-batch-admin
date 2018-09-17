<#import "/spring.ftl" as spring />
<#escape x as x?html>
<div id="job-execution">

	<#if jobExecutionInfoWithComment??>
		<h2>Details for Job Execution</h2>

		<#if jobExecutionInfoWithComment.jobExecutionInfo.stoppable || jobExecutionInfoWithComment.jobExecutionInfo.abandonable>
			<#assign execution_url><@spring.url relativeUrl="${servletPath}/jobs/executions/${jobExecutionInfoWithComment.jobExecutionInfo.id?c}"/></#assign>

			<form id="stopForm" action="${execution_url}" method="post">
		
				<#if stopRequest??>
					<@spring.bind path="stopRequest" />
					<@spring.showErrors separator="<br/>" classOrStyle="error" /><br/>
				</#if>
		
				<#if jobExecutionInfoWithComment.jobExecutionInfo.abandonable>
					<#assign stop_label="Abandon"/> 
					<#assign stop_param="abandon"/>
				<#else>
					<#assign stop_label="Stop"/>
					<#assign stop_param="stop"/>
				</#if>
				<ol>
					<li>
					<input id="stop" type="submit" value="${stop_label}" name="${stop_param}" />
					<input type="hidden" name="_method" value="DELETE"/>
					</li>
				</ol>
			
			</form>
		</#if>

		<#if jobExecutionInfoWithComment.jobExecutionInfo.restartable>
			<#assign jobs_url><@spring.url relativeUrl="${servletPath}/jobs/${jobExecutionInfoWithComment.jobExecutionInfo.name}/${jobExecutionInfoWithComment.jobExecutionInfo.jobId?c}/executions"/></#assign>
			<form id="restartForm" action="${jobs_url}" method="post">

				<ol>
					<li>
					<input id="restart" type="submit" value="Restart" name="restart" />
					</li>
				</ol>
			
			</form>
		</#if>

		<table title="Job Execution Details"
			class="bordered-table">
			<tr>
				<th>Property</th>
				<th>Value</th>
			</tr>
			<tr class="name-sublevel1-odd">
				<td>ID</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.id}</td>
			</tr>
			<tr class="name-sublevel1-even">
				<#assign job_url><@spring.url relativeUrl="${servletPath}/jobs/${jobExecutionInfoWithComment.jobExecutionInfo.name}"/></#assign>
				<td>Job Name</td>
				<td><a href="${job_url}"/>${jobExecutionInfoWithComment.jobExecutionInfo.name}</a></td>
			</tr>
			<tr class="name-sublevel1-odd">
				<#assign job_url><@spring.url relativeUrl="${servletPath}/jobs/${jobExecutionInfoWithComment.jobExecutionInfo.name}/${jobExecutionInfoWithComment.jobExecutionInfo.jobId?c}/executions"/></#assign>
				<td>Job Instance</td>
				<td><a href="${job_url}"/>${jobExecutionInfoWithComment.jobExecutionInfo.jobId}</a></td>
			</tr>
			<tr class="name-sublevel1-even">
				<td>Job Parameters</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.jobParametersString}</td>
			</tr>
			<tr class="name-sublevel1-odd">
				<td>Start Date</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.startDate}</td>
			</tr>
			<tr class="name-sublevel1-even">
				<td>Start Time</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.startTime}</td>
			</tr>
			<tr class="name-sublevel1-odd">
				<td>Duration</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.duration}</td>
			</tr>
			<tr class="name-sublevel1-even">
				<td>Status</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.status}</td>
			</tr>
			<tr class="name-sublevel1-odd">
				<td>Exit Code</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.exitStatus.exitCode}</td>
			</tr>
			<tr class="name-sublevel1-even">
				<td>Exit Message</td>
				<td>${jobExecutionInfoWithComment.jobExecutionInfo.jobExecution.exitStatus.exitDescription}</td>
			</tr>
			<tr class="name-sublevel1-odd">
				<#assign url><@spring.url relativeUrl="${servletPath}/jobs/executions/${jobExecutionInfoWithComment.jobExecutionInfo.id?c}/steps"/></#assign>
				<td>Step Executions Count</td>
				<td><a href="${url}"/>${jobExecutionInfoWithComment.jobExecutionInfo.stepExecutionCount}</a></td>
			</tr>
      <tr class="name-sublevel1-even">
        <td>Comment</td>
        <td>
          <div>
            <#assign executions_url><@spring.url relativeUrl="${servletPath}/jobs/executions"/></#assign>
            <form id="saveForm${jobExecutionInfoWithComment.jobExecutionInfo.id?c}"
                  onsubmit="JavaScript:saveComment('${executions_url}', ${jobExecutionInfoWithComment.jobExecutionInfo.id?c}); return false;">
              <input id="comment" type="text" name="comment" value="${jobExecutionInfoWithComment.comment.comment}"/>
              <input type="hidden" id="id" name="id" value="${jobExecutionInfoWithComment.jobExecutionInfo.id?c}"/>
              <input type="hidden" id="jobId" name="jobId"
                     value="${jobExecutionInfoWithComment.jobExecutionInfo.jobId?c}"/>
              <input name="submit" type="submit" value="Valider"/>
            </form>
          </div>
        </td>
      </tr>
		</table>
	
<#if stepExecutionInfos?? && stepExecutionInfos?size != 0>
		<br/>
		<table title="Step Execution Status"
			class="bordered-table">
			<tr>
				<th>StepName</th>
				<th>Reads</th>
				<th>Writes</th>
				<th>Commits</th>
				<th>Rollbacks</th>
				<th>Duration</th>
				<th>Status</th>
			</tr>
			<#list stepExecutionInfos as execution>
				<#if execution_index % 2 == 0>
					<#assign rowClass="name-sublevel1-even" />
				<#else>
					<#assign rowClass="name-sublevel1-odd" />
				</#if>
				<tr class="${rowClass}">
					<td>${execution.name}</td>
					<td>${execution.stepExecution.readCount}</td>
					<td>${execution.stepExecution.writeCount}</td>
					<td>${execution.stepExecution.commitCount}</td>
					<td>${execution.stepExecution.rollbackCount}</td>
					<td>${execution.duration}</td>
					<td>
						<#if execution.status == "NONE">${execution.status}<#else>
						<#assign url><@spring.url relativeUrl="${servletPath}/jobs/executions/${jobExecutionInfoWithComment.jobExecutionInfo.id?c}/steps/${execution.id?c}/progress"/></#assign>
						<a href="${url}"/>${execution.status}</a>
						</#if>
					</td>
				</tr>
			</#list>
		</table>
</#if>

	<#else>
		<p>There is no job execution to display.</p>
	</#if>
	<#assign url><@spring.url relativeUrl="${servletPath}/resources/js/executions.js"/></#assign>
  <script src="${url}" type="text/javascript"></script>
</div><!-- job-execution -->
</#escape>