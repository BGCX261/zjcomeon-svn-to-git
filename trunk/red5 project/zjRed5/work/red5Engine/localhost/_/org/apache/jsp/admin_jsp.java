package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import org.springframework.security.providers.encoding.*;
import org.apache.derby.jdbc.*;
import javax.sql.*;
import java.sql.*;

public final class admin_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("  \r\n");

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

      out.write("\r\n");
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\r\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en\" xml:lang=\"en\">\r\n");
      out.write("<head>\r\n");
      out.write("  <title>Red5 Admin</title>\r\n");
      out.write("  <meta content=\"text/html; charset=iso-8859-1\" http-equiv=\"Content-Type\" />\r\n");
      out.write("  <style type=\"text/css\" media=\"screen\">\r\n");
      out.write("html, body, #containerA, #containerB { height: 100%;\r\n");
      out.write("}\r\n");
      out.write(".formbg { background-color: rgb(238, 238, 238);\r\n");
      out.write("}\r\n");
      out.write(".formtable { border: 2px solid rgb(183, 186, 188);\r\n");
      out.write("}\r\n");
      out.write(" \r\n");
      out.write(".formtext { font-family: Arial,Helvetica,sans-serif;\r\n");
      out.write("    font-size: 12px;\r\n");
      out.write("    color: rgb(11, 51, 73);\r\n");
      out.write("}\r\n");
      out.write(" \r\n");
      out.write("body { margin: 0pt;\r\n");
      out.write("padding: 0pt;\r\n");
      out.write("overflow: hidden;\r\n");
      out.write("background-color: rgb(250, 250, 250);\r\n");
      out.write("}\r\n");
      out.write(".error {\r\n");
      out.write("                font-family: Arial,Helvetica,sans-serif;\r\n");
      out.write("                font-size: 12px;\r\n");
      out.write("                color: red;\r\n");
      out.write("}\r\n");
      out.write("  </style>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<table style=\"text-align: left; width: 100%; height: 100%;\" border=\"0\" cellpadding=\"0\" cellspacing=\"10\">\r\n");
      out.write("  <tbody>\r\n");
      out.write("    <tr>\r\n");
      out.write("      <td height=\"54\"><img style=\"width: 136px; height: 54px;\" alt=\"\" src=\"biglogo.png\" /></td>\r\n");
      out.write("    </tr>\r\n");
      out.write("    <tr class=\"formbg\">\r\n");
      out.write("      <td align=\"center\" valign=\"middle\">\r\n");
      out.write("      <table style=\"width: 400px;\" class=\"formtable\" border=\"0\" cellpadding=\"0\" cellspacing=\"2\">\r\n");
      out.write("      <tr>\r\n");
      out.write("                <td class=\"formtext\">&nbsp;<b>Register Admin User</b></td>\r\n");
      out.write("      </tr>\r\n");
      out.write("      <tr>\r\n");
      out.write("      <td>\r\n");
      out.write("      <form method=\"post\">\r\n");
      out.write("      <input type=\"hidden\" name=\"cambia\" value=\"vai\" />\r\n");
      out.write("        <table style=\"width: 400px;\"  border=\"0\" cellpadding=\"0\" cellspacing=\"5\">\r\n");
      out.write("          <tbody>\r\n");
      out.write("            <tr>\r\n");
      out.write("              <td align=\"right\" width=\"20%\" class=\"formtext\">Username:</td>\r\n");
      out.write("                                       <td width=\"20%\">\r\n");
      out.write("                                           <input name=\"username\" value=\"\" />\r\n");
      out.write("                                       </td>\r\n");
      out.write("                                    </tr>\r\n");
      out.write("            <tr>\r\n");
      out.write("                                                 <td align=\"right\" width=\"20%\" class=\"formtext\">Password:</td>\r\n");
      out.write("                                       <td width=\"20%\">\r\n");
      out.write("                                         <input type=\"password\" name=\"password\" value=\"\" />\r\n");
      out.write("                                       </td>\r\n");
      out.write("                                    </tr>\r\n");
      out.write("            <tr>\r\n");
      out.write("                                                 <td align=\"right\" width=\"20%\" class=\"formtext\">New Password:</td>\r\n");
      out.write("                                       <td width=\"20%\">\r\n");
      out.write("                                         <input type=\"newPassword\" name=\"newPassword\" value=\"\" />\r\n");
      out.write("                                       </td>\r\n");
      out.write("                                    </tr>\r\n");
      out.write("            <tr>\r\n");
      out.write("              <td colspan=\"2\" align=\"center\">\r\n");
      out.write("\t\t\t  <i>If you are creating a new user, leave the &quot;New Password&quot; field blank</i>\r\n");
      out.write("\t\t\t  <br />\r\n");
      out.write("\t\t\t  <input type=\"submit\" value=\"Submit\" /></td>\r\n");
      out.write("              <td></td>\r\n");
      out.write("              <td class=\"error\">\r\n");
      out.write("              </td>\r\n");
      out.write(" \r\n");
      out.write("            </tr>\r\n");
      out.write("          </tbody>\r\n");
      out.write("        </table>\r\n");
      out.write("      </form>\r\n");
      out.write("      </td>\r\n");
      out.write("      </tr>\r\n");
      out.write("      </table>\r\n");
      out.write("      </td>\r\n");
      out.write("    </tr>\r\n");
      out.write(" \r\n");
      out.write("  </tbody>\r\n");
      out.write("</table>\r\n");
      out.write("<br />\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
