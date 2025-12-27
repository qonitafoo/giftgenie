package servlet;

import model.UserRepository;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("./");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        String jsonPath = getServletContext().getRealPath("/users.json");

        // --- SIGN UP ---
        if ("signup".equalsIgnoreCase(mode)) {
            String name = req.getParameter("name");
            UserRepository.addUser(jsonPath, name, email, password);
            resp.sendRedirect("./?mode=login&msg=Account created! Please login.");
            return;
        }

        // --- LOGIN ---
        if (UserRepository.isValid(jsonPath, email, password)) {
            HttpSession session = req.getSession();
            session.setAttribute("userEmail", email);
            
            String realName = UserRepository.findNameByEmail(jsonPath, email);
            session.setAttribute("userName", realName);

            resp.sendRedirect("catalog"); 

        } else {
            resp.sendRedirect("./?mode=login&msg=Invalid email or password");
        }
    }
}