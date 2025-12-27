package servlet;

import model.CartItem;
import model.Product;
import model.ProductRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.net.URLEncoder;

public class CartServlet extends HttpServlet {

    private double calcTotal(List<CartItem> cart) {
        double total = 0.0;
        for (CartItem item : cart) {
            total += item.getTotal();
        }
        return total;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            resp.sendRedirect("./?mode=login&msg=Please login to view cart");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        req.setAttribute("cart", cart);
        req.setAttribute("total", calcTotal(cart));

        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            resp.sendRedirect("./?mode=login");
            return;
        }

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        
        String redirect = req.getParameter("redirect");
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        String msg = ""; 

        try {
            int id = Integer.parseInt(idStr);

            if ("add".equals(action)) {
                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == id) {
                        item.setQty(item.getQty() + 1);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    String jsonPath = getServletContext().getRealPath("/products.json");
                    Product p = ProductRepository.findById(jsonPath, id);
                    if (p != null) cart.add(new CartItem(p, 1));
                }
                msg = "Item added to cart!";
            } 
            else if ("removeOne".equals(action)) {
                Iterator<CartItem> it = cart.iterator();
                while (it.hasNext()) {
                    CartItem item = it.next();
                    if (item.getProduct().getId() == id) {
                        if (item.getQty() > 1) {
                            item.setQty(item.getQty() - 1);
                        } else {
                            it.remove();
                        }
                        break;
                    }
                }
                msg = "Item removed.";
            } 
            else if ("removeAll".equals(action)) {
                cart.removeIf(item -> item.getProduct().getId() == id);
                msg = "Item removed.";
            }

        } catch (Exception e) {
        }

        if (redirect != null && !redirect.isEmpty()) {
            resp.sendRedirect(redirect + "?msg=" + URLEncoder.encode(msg, "UTF-8"));
        } else {
            resp.sendRedirect("cart");
        }
    }
}