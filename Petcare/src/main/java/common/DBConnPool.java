package common;

import java.sql.*;
import javax.naming.*;
import javax.sql.DataSource;

/**
 * 톰캣 DBCP(DataSource)를 통해 커넥션을 얻어오는 공용 베이스 클래스입니다.
 * - JNDI 이름은 context.xml 설정과 반드시 동일해야 합니다.
 * - 예: <Resource name="jdbc/urdb" type="javax.sql.DataSource" .../>
 */
public class DBConnPool {
    protected Connection con;
    protected PreparedStatement psmt;
    protected ResultSet rs;

    public DBConnPool() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context)initContext.lookup("java:/comp/env");
            // context.xml에서 설정한 JNDI 이름과 아래 lookup 값이 일치해야 합니다.
            // 예제: name="jdbc/urdb" 로 등록했다면 lookup("jdbc/urdb")로 조회
            DataSource ds = (DataSource)envContext.lookup("jdbc/urdb"); // context.xml에서 설정한 이름
            con = ds.getConnection();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void close() {
        // finally 블록에서 호출하여 JDBC 리소스를 정리합니다.
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(psmt != null) psmt.close(); } catch(Exception e) {}
        try { if(con != null) con.close(); } catch(Exception e) {}
    }
}
