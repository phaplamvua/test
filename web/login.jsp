<%-- 
    Document   : login
    Created on : Jun 23, 2025, 6:16:20 PM
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
                height: 100vh;
                margin: 0;
                background-color: #f0f0f0;
            }
            .login-container {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                width: 300px;
                text-align: center;
            }
            .login-container h2 {
                margin-bottom: 20px;
                color: #333;
            }
            .login-container input[type="text"],
            .login-container input[type="password"] {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .login-container input[type="submit"] {
                width: 100%;
                padding: 10px;
                background-color: #4CAF50;
                border: none;
                border-radius: 4px;
                color: white;
                font-size: 16px;
                cursor: pointer;
            }
            .login-container input[type="submit"]:hover {
                background-color: #45a049;
            }
            .error {
                color: red;
                font-size: 14px;
                margin-bottom: 10px;
            }
            .signup-link {
                margin-top: 15px;
                font-size: 14px;
            }
            .signup-link a {
                color: #4CAF50;
                text-decoration: none;
            }
            .signup-link a:hover {
                text-decoration: underline;
            }
            .remember-me {
                display: flex;
                align-items: center;
                justify-content: flex-start;
                margin: 10px 0;
            }
            .remember-me input[type="checkbox"] {
                margin-right: 5px;
            }
            .remember-me label {
                font-size: 14px;
                color: #333;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h2>Login</h2>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
hello someone
            <form action="${pageContext.request.contextPath}/MainController?entity=account&action=login" method="post">
                <input type="text" name="account" placeholder="Account" value="${param.account}" required>
                <input type="password" name="pass" placeholder="Password" required>
                <div class="remember-me">
                    <input type="checkbox" name="rememberMe" id="rememberMe">
                    <label for="rememberMe">Remember Me</label>
                </div>
                <input type="submit" value="Login">
            </form>
            <div class="signup-link">
                Don't have an account? <a href="${pageContext.request.contextPath}/signup.jsp">Sign Up</a>
            </div>
        </div>
    </body>
</html>
