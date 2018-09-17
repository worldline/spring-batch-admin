package org.springframework.batch.admin.domain;

/**
 * Represents job execution comment.
 *
 * @author Assia CHIGUEUR
 */
public class Comment {

    private Long jobId;
    private Long jobExecutionId;
    private String comment;

    public Comment() {
        this.comment = "";
    }

    public Comment(Long jobId, Long jobExecutionId, String comment) {
        this.jobId = jobId;
        this.jobExecutionId = jobExecutionId;
        this.comment = comment;
    }

    @Override
    public String toString() {
        return "Comment{" +
                "jobId=" + jobId +
                ", jobExecutionId=" + jobExecutionId +
                ", comment='" + comment + '\'' +
                '}';
    }

    public Long getJobId() {
        return jobId;
    }

    public Long getJobExecutionId() {
        return jobExecutionId;
    }

    public String getComment() {
        return comment;
    }

    public void setJobId(Long jobId) {
        this.jobId = jobId;
    }

    public void setJobExecutionId(Long jobExecutionId) {
        this.jobExecutionId = jobExecutionId;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Comment comment1 = (Comment) o;

        if (jobId != null ? !jobId.equals(comment1.jobId) : comment1.jobId != null) return false;
        if (jobExecutionId != null ? !jobExecutionId.equals(comment1.jobExecutionId) : comment1.jobExecutionId != null)
            return false;
        return comment != null ? comment.equals(comment1.comment) : comment1.comment == null;
    }

    @Override
    public int hashCode() {
        int result = jobId != null ? jobId.hashCode() : 0;
        result = 31 * result + (jobExecutionId != null ? jobExecutionId.hashCode() : 0);
        result = 31 * result + (comment != null ? comment.hashCode() : 0);
        return result;
    }
}
