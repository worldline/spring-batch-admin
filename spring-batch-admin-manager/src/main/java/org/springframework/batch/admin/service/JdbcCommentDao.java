package org.springframework.batch.admin.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.admin.domain.Comment;
import org.springframework.batch.core.repository.dao.AbstractJdbcBatchMetadataDao;
import org.springframework.batch.core.repository.dao.JdbcJobExecutionDao;
import org.springframework.batch.item.database.PagingQueryProvider;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.util.Assert;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

import static org.apache.commons.lang.StringEscapeUtils.escapeSql;

/**
 * @author Assia CHIGUEUR
 */
public class JdbcCommentDao extends AbstractJdbcBatchMetadataDao {

    private static Log logger = LogFactory.getLog(JdbcCommentDao.class);

    private static final String INSERT_QUERY = "INSERT INTO BATCH_COMMENT (JOB_ID, JOB_EXEC_ID, COMMENT) VALUES ('%s','%s','%s')";
    private static final String UPDATE_QUERY = "UPDATE BATCH_COMMENT SET COMMENT = '%s' WHERE JOB_ID = '%s' AND JOB_EXEC_ID = '%s'";
    private static final String GET_COUNT = "SELECT COUNT(1) FROM BATCH_COMMENT";
    private static final String FIELDS = "C.JOB_ID, C.JOB_EXEC_ID, C.COMMENT";
    private static final String GET_COMMENTS = "SELECT " + FIELDS
            + " FROM BATCH_COMMENT C ";
    private static final String GET_COMMENT = "SELECT " + FIELDS
            + " FROM BATCH_COMMENT C "
            + " WHERE C.JOB_ID = %s AND C.JOB_EXEC_ID = %s ";

    private PagingQueryProvider allExecutionsPagingQueryProvider;

    private PagingQueryProvider byJobNamePagingQueryProvider;

    private DataSource dataSource;

    /**
     * @param dataSource the dataSource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    /**
     * @see JdbcJobExecutionDao#afterPropertiesSet()
     */
    @Override
    public void afterPropertiesSet() throws Exception {
        Assert.state(dataSource != null, "DataSource must be provided");
        if (getJdbcTemplate() == null) {
            setJdbcTemplate(new JdbcTemplate(dataSource));
        }
        super.afterPropertiesSet();
    }

    public int countJobExecutions() {
        return getJdbcTemplate().queryForObject(getQuery(GET_COUNT), Integer.class);
    }

    public Collection<Comment> getComments() {
        return getJdbcTemplate().query(getQuery(GET_COMMENTS), new CommentRowMapper());
    }

    public Comment getComment(Long jobId, Long jobExecutionId) {
        logger.debug("GET QUERY : " + getQuery(String.format(GET_COMMENT, jobId, jobExecutionId)));

        return getJdbcTemplate().query(getQuery(String.format(GET_COMMENT, jobId, jobExecutionId)), new CommentRowExtractor());
    }

    public void saveComment(Long jobId, Long jobExecutionId, String comment) {
        saveComment(new Comment(jobId, jobExecutionId, comment));
    }

    public void saveComment(Comment comment) {
        Comment c = getComment(comment.getJobId(), comment.getJobExecutionId());
        if (c.getJobId() != null) {
            logger.debug("UPDATE Query : " + String.format(INSERT_QUERY, comment.getJobId(), comment.getJobExecutionId(), escapeSql(comment.getComment())));
            getJdbcTemplate().update(String.format(UPDATE_QUERY, escapeSql(comment.getComment()), comment.getJobId(), comment.getJobExecutionId()));

        } else {
            logger.debug("INSERT Query : " + String.format(INSERT_QUERY, comment.getJobId(), comment.getJobExecutionId(), escapeSql(comment.getComment())));

            getJdbcTemplate().update(String.format(INSERT_QUERY, comment.getJobId(), comment.getJobExecutionId(), escapeSql(comment.getComment())));
        }
    }

    protected class CommentRowExtractor implements ResultSetExtractor<Comment> {

        public CommentRowExtractor() {
        }

        @Override
        public Comment extractData(ResultSet rs) throws SQLException, DataAccessException {
            if (!rs.next()) {
                return new Comment();
            }
            logger.debug(String.format("Contenu de resultSet dans CommentRowExtractor --> %s", rs));
            Long jobId = rs.getLong(1);
            Long jobExecutionId = rs.getLong(2);
            String comment = rs.getString(3);
            return new Comment(jobId, jobExecutionId, comment);
        }
    }

    protected class CommentRowMapper implements RowMapper<Comment> {

        public CommentRowMapper() {
        }

        @Override
        public Comment mapRow(ResultSet rs, int rowNum) throws SQLException {
            Long jobId = rs.getLong(1);
            Long jobExecutionId = rs.getLong(2);
            String comment = rs.getString(3);
            return new Comment(jobId, jobExecutionId, comment);
        }
    }
}
