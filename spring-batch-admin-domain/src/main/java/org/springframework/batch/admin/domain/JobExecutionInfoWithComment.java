package org.springframework.batch.admin.domain;

/**
 * Represents job execution info with the comment added.
 *
 * @author Assia CHIGUEUR
 */
public class JobExecutionInfoWithComment {

    private JobExecutionInfo jobExecutionInfo;
    private Comment comment;

    public JobExecutionInfoWithComment(JobExecutionInfo jobExecutionInfo, Comment comment) {
        this.jobExecutionInfo = jobExecutionInfo;
        this.comment = comment;
    }

    public Comment getComment() {
        return comment;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }

    public JobExecutionInfo getJobExecutionInfo() {
        return jobExecutionInfo;
    }

    public void setJobExecutionInfo(JobExecutionInfo jobExecutionInfo) {
        this.jobExecutionInfo = jobExecutionInfo;
    }
}