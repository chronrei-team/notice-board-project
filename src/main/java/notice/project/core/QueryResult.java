package notice.project.core;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

// 리소스를 묶어서 관리할 간단한 컨테이너 클래스
public class QueryResult implements AutoCloseable {
    private final PreparedStatement statement;
    public final ResultSet Set;

    public QueryResult(PreparedStatement statement, ResultSet resultSet) {
        this.statement = statement;
        this.Set = resultSet;
    }

    @Override
    public void close() throws SQLException {
        SQLException firstException = null;
        try {
            if (Set != null) {
                Set.close();
            }
        } catch (SQLException e) {
            firstException = e;
        }
        try {
            if (statement != null) {
                statement.close();
            }
        } catch (SQLException e) {
            if (firstException == null) {
                firstException = e;
            } else {
                firstException.addSuppressed(e); // Java 7+
            }
        }
        if (firstException != null) {
            throw firstException;
        }
    }
}
