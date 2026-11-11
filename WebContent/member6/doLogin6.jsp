<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="dao.*,model.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    MemberDAO6 dao = new MemberDAO6();
    Member6 member = dao.checkLogin(username, password);

    if (member instanceof Customer6) {
        session.setAttribute("customer6", member);
        response.sendRedirect("../customer6/customerHomeFrm6.jsp");
    } else if (member instanceof Manager6) {
        session.setAttribute("manager6", member);
        response.sendRedirect("../manager6/managerHomeFrm6.jsp");
    } else if (member != null) {
        // nhan vien ban hang / giao hang: chua cai dat giao dien trong pham vi 2 module
        response.sendRedirect("loginFrm6.jsp?err=role");
    } else {
        response.sendRedirect("loginFrm6.jsp?err=fail");
    }
%>
