<%@ page language="java" import="org.springframework.security.providers.encoding.*,org.apache.derby.jdbc.*,javax.sql.*,java.sql.*" %>  
<%
if(request.getParameter("cambia")!=null){
                               String prop = System.getenv("DERBY_HOME");
 
                               if (prop == null) {
                                               prop = System.getProperty("user.home");
                               }
                               System.setProperty("derby.system.home", prop);
                              
                               Connection conn = null;
                               Statement stmt = null;
                               try {
            // JDBC stuff
                                               DataSource ds = null;
                                               try {
                                                               Object o = null;
                                                               if (o == null) {
                                                                              EmbeddedDataSource eds = new EmbeddedDataSource();
                                                                              eds.setCreateDatabase("create");
                                                                              eds.setDatabaseName("Admin");
                                                                              eds.setPassword("APP");
                                                                              eds.setUser("APP");
 
                                                                              ds = eds;
                                                               } else {
                                                                              ds = (DataSource) o;
                                                               }
                                               } catch (Exception e) {
                                                               out.println("Context check for datasource " + e.getMessage() );
                                               }
                                              
                                               //create the db and get a connection
                                               conn = ds.getConnection();
                                               //make a statement
                                               stmt = conn.createStatement();

                                               Md5PasswordEncoder md5 = new Md5PasswordEncoder();
											   
                                               String user = request.getParameter("username");
                                               String password = request.getParameter("password");
                                               String newPassword = request.getParameter("newPassword");

											String alert = null;
											   
										   if (newPassword == null || newPassword.length() < 1) {
											    //new user
                                               password = md5.encodePassword(password, "seKret").toString();
                                               stmt.execute("INSERT INTO APPUSER (username, password, enabled) VALUES ('"+user+"', '"+password+"', 'enabled')");
											   stmt.execute("INSERT INTO APPROLE (username, authority) VALUES ('"+user+"', 'ROLE_SUPERVISOR')");
											   
											   alert = "User " + user + " added";
											} else {
											    //update
                                               password = md5.encodePassword(password, "seKret").toString();
                                               newPassword = md5.encodePassword(newPassword, "seKret").toString();
                                               stmt.execute("UPDATE APPUSER SET password='"+newPassword+"', enabled='enabled' WHERE username='"+user+"' and password = '"+password+"'");											   

											   alert = "User " + user + " updated";
										   }
										   
										   out.print("<script>alert(" + alert + ");</script>");
                                              
                               } catch (Exception e) {
                                               out.println("Error in db setup " + e.getMessage());
                               } finally {
                                               if (stmt != null) {
                                                               try {
                                                                              stmt.close();
                                                               } catch (SQLException e) {
                                                               }
                                               }
                                               if (conn != null) {
                                                               try {
                                                                              conn.close();
                                                               } catch (SQLException e) {
                                                               }
                                               }
                               }
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <title>Red5 Admin</title>
  <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />
  <style type="text/css" media="screen">
html, body, #containerA, #containerB { height: 100%;
}
.formbg { background-color: rgb(238, 238, 238);
}
.formtable { border: 2px solid rgb(183, 186, 188);
}
 
.formtext { font-family: Arial,Helvetica,sans-serif;
    font-size: 12px;
    color: rgb(11, 51, 73);
}
 
body { margin: 0pt;
padding: 0pt;
overflow: hidden;
background-color: rgb(250, 250, 250);
}
.error {
                font-family: Arial,Helvetica,sans-serif;
                font-size: 12px;
                color: red;
}
  </style>
</head>
<body>
<table style="text-align: left; width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="10">
  <tbody>
    <tr>
      <td height="54"><img style="width: 136px; height: 54px;" alt="" src="biglogo.png" /></td>
    </tr>
    <tr class="formbg">
      <td align="center" valign="middle">
      <table style="width: 400px;" class="formtable" border="0" cellpadding="0" cellspacing="2">
      <tr>
                <td class="formtext">&nbsp;<b>Register Admin User</b></td>
      </tr>
      <tr>
      <td>
      <form method="post">
      <input type="hidden" name="cambia" value="vai" />
        <table style="width: 400px;"  border="0" cellpadding="0" cellspacing="5">
          <tbody>
            <tr>
              <td align="right" width="20%" class="formtext">Username:</td>
                                       <td width="20%">
                                           <input name="username" value="" />
                                       </td>
                                    </tr>
            <tr>
                                                 <td align="right" width="20%" class="formtext">Password:</td>
                                       <td width="20%">
                                         <input type="password" name="password" value="" />
                                       </td>
                                    </tr>
            <tr>
                                                 <td align="right" width="20%" class="formtext">New Password:</td>
                                       <td width="20%">
                                         <input type="newPassword" name="newPassword" value="" />
                                       </td>
                                    </tr>
            <tr>
              <td colspan="2" align="center">
			  <i>If you are creating a new user, leave the &quot;New Password&quot; field blank</i>
			  <br />
			  <input type="submit" value="Submit" /></td>
              <td></td>
              <td class="error">
              </td>
 
            </tr>
          </tbody>
        </table>
      </form>
      </td>
      </tr>
      </table>
      </td>
    </tr>
 
  </tbody>
</table>
<br />
</body>
</html>