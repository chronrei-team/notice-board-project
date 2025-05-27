package notice.project.core;

import java.sql.*;

public abstract class BaseRepository {
    private Connection conn;

    public void setConnection(Connection connection) {
        this.conn = connection;
        if (conn != null) {
            System.out.println("ExampleRepositoryImpl received connection: " + connection);
        } else {
            System.out.println("ExampleRepositoryImpl connection cleared.");
        }
    }

    private static void setParameters(PreparedStatement pstmt, Object... params) throws SQLException {
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                Object param = params[i];
                int jdbcIndex = i + 1; // JDBC 파라미터 인덱스는 1부터 시작

                if (param == null) {
                    // NULL 값을 설정할 때는 SQL 타입을 명시해주는 것이 좋습니다.
                    // 모든 경우에 동작하도록 Types.NULL 또는 Types.OTHER를 사용할 수 있지만,
                    // 컬럼 타입에 맞는 구체적인 타입을 알면 더 좋습니다 (예: Types.VARCHAR, Types.INTEGER).
                    // setObject(index, null)도 많은 드라이버에서 잘 동작합니다.
                    pstmt.setObject(jdbcIndex, null);
                    // pstmt.setNull(jdbcIndex, Types.NULL); // 또는 Types.VARCHAR 등
                } else if (param instanceof String) {
                    pstmt.setString(jdbcIndex, (String) param);
                } else if (param instanceof Integer) {
                    pstmt.setInt(jdbcIndex, (Integer) param);
                } else if (param instanceof Long) {
                    pstmt.setLong(jdbcIndex, (Long) param);
                } else if (param instanceof Double) {
                    pstmt.setDouble(jdbcIndex, (Double) param);
                } else if (param instanceof Float) {
                    pstmt.setFloat(jdbcIndex, (Float) param);
                } else if (param instanceof Boolean) {
                    pstmt.setBoolean(jdbcIndex, (Boolean) param);
                } else if (param instanceof java.sql.Date) {
                    pstmt.setDate(jdbcIndex, (java.sql.Date) param);
                } else if (param instanceof java.sql.Time) {
                    pstmt.setTime(jdbcIndex, (java.sql.Time) param);
                } else if (param instanceof java.sql.Timestamp) {
                    pstmt.setTimestamp(jdbcIndex, (java.sql.Timestamp) param);
                } else if (param instanceof java.util.Date) {
                    // java.util.Date는 java.sql.Timestamp로 변환
                    pstmt.setTimestamp(jdbcIndex, new Timestamp(((java.util.Date) param).getTime()));
                } else {
                    // 기타 타입은 setObject로 처리 (JDBC 드라이버가 변환 시도)
                    // 특정 타입에 대한 처리가 더 필요하면 여기에 추가
                    pstmt.setObject(jdbcIndex, param);
                }
            }
        }
    }

    protected void executeCommand(String sql, Object... params) throws SQLException {
        try (var pstmt = conn.prepareStatement(sql)) {
            setParameters(pstmt, params);
            pstmt.executeUpdate();
        }
    }

    protected QueryResult executeQuery(String sql, Object... params) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql); // conn은 클래스 멤버 변수 등으로 가정
            setParameters(pstmt, params); // setParameters는 직접 구현해야 함
            rs = pstmt.executeQuery();
            return new QueryResult(pstmt, rs); // pstmt와 rs를 함께 반환
        } catch (SQLException e) {
            // 예외 발생 시, 생성된 리소스가 있다면 닫아줘야 함
            if (rs != null) try { rs.close(); } catch (SQLException suppressed) { e.addSuppressed(suppressed); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException suppressed) { e.addSuppressed(suppressed); }
            throw e;
        }
    }
}
