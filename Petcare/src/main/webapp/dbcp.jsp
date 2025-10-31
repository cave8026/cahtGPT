<%@page import="javax.naming.InitialContext"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.Context"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!--
    dbcp.jsp - DBCP(DataBase Connection Pool) 연결 확인용 페이지입니다.
    개발/학습 목적: JNDI로 등록된 DataSource를 조회하여 Connection을 얻는 동작을 확인합니다.
    실제 서비스에서는 JSP에서 직접 DB 연결 코드를 작성하지 말고 DAO 등으로 분리하세요.
    주의: 아래 lookup("jdbc/urdb")의 JNDI 이름은 서버 context.xml의 Resource name과 반드시 일치해야 합니다.
-->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DBCP 연결 테스트</title>
</head>
<body>
<%
Context initContext = new InitialContext();
Context envContext  = (Context)initContext.lookup("java:/comp/env");
DataSource ds = (DataSource)envContext.lookup("jdbc/urdb");
Connection conn = ds.getConnection();
out.println("DBCP 연결 성공");
%>
</body>
</html>