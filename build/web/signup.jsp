<%-- 
    Document   : signup
    Created on : Jun 24, 2025, 6:07:26 PM
    Author     : phapl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                background-color: #f0f0f0;
            }
            .signup-container {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                width: 350px;
                text-align: center;
            }
            .signup-container h2 {
                margin-bottom: 20px;
                color: #333;
            }
            .signup-container input[type="text"],
            .signup-container input[type="password"],
            .signup-container input[type="date"],
            .signup-container select {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .signup-container input[type="submit"] {
                width: 100%;
                padding: 10px;
                background-color: #4CAF50;
                border: none;
                border-radius: 4px;
                color: white;
                font-size: 16px;
                cursor: pointer;
            }
            .signup-container input[type="submit"]:hover {
                background-color: #45a049;
            }
            .error {
                color: red;
                font-size: 14px;
                margin-bottom: 10px;
            }
            .login-link {
                margin-top: 15px;
                font-size: 14px;
            }
            .login-link a {
                color: #4CAF50;
                text-decoration: none;
            }
            .login-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="signup-container">
            <h2>Sign Up</h2>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/MainController?entity=account&action=add" method="post">
                <input type="text" name="account" placeholder="Account" value="${param.account}" required>
                <input type="password" name="pass" placeholder="Password" required>
                <input type="text" name="lastName" placeholder="Last Name" value="${param.lastName}" required>
                <input type="text" name="firstName" placeholder="First Name" value="${param.firstName}" required>
                <input type="date" name="birthday" value="${param.birthday}" required>
                <select name="gender" required>
                    <option value="" disabled selected>Select Gender</option>
                    <option value="true" ${param.gender == 'true' ? 'selected' : ''}>Male</option>
                    <option value="false" ${param.gender == 'false' ? 'selected' : ''}>Female</option>
                </select>
                <input type="text" name="phone" placeholder="Phone" value="${param.phone}" required>
                <input type="hidden" name="roleInSystem" value="2">
                <input type="submit" value="Sign Up">
            </form>
            <div class="login-link">
                Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
            </div>
        </div>
    </body>
</html>
