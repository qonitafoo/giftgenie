package servlet;

import model.CartItem;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class CheckoutServlet extends HttpServlet {

    // --- HELPER METHODS ---

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private double calcTotal(List<CartItem> cart) {
        double total = 0.0;
        if (cart == null) return 0.0;
        for (CartItem it : cart) {
            Product p = it.getProduct();
            if (p != null) total += p.getPrice() * it.getQty();
        }
        return total;
    }

    // --- VALIDATION HELPERS ---

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private boolean isEmailLike(String s) {
        if (isBlank(s)) return false;
        s = s.trim();
        return s.contains("@") && s.contains(".");
    }

    private boolean isDigits(String s) {
        if (isBlank(s)) return false;
        for (int i = 0; i < s.length(); i++) {
            if (!Character.isDigit(s.charAt(i))) return false;
        }
        return true;
    }

    private boolean isCardLike(String s) {
        if (isBlank(s)) return false;
        s = s.replaceAll("\\s+", "");
        return isDigits(s) && s.length() >= 12 && s.length() <= 19;
    }

    private boolean isExpiryLike(String s) {
        if (isBlank(s)) return false;
        s = s.trim();
        if (!s.matches("\\d{2}/\\d{2}")) return false;
        int mm = Integer.parseInt(s.substring(0, 2));
        return mm >= 1 && mm <= 12;
    }

    private boolean isCvvLike(String s) {
        if (isBlank(s)) return false;
        s = s.trim();
        return isDigits(s) && (s.length() == 3 || s.length() == 4);
    }

    private List<CartItem> snapshotCart(List<CartItem> cart) {
        List<CartItem> snap = new ArrayList<>();
        if (cart == null) return snap;
        for (CartItem it : cart) {
            if (it != null && it.getProduct() != null) {
                snap.add(new CartItem(it.getProduct(), it.getQty()));
            }
        }
        return snap;
    }

    // --- SAVE TO CSV ---
    private void saveOrderToCsv(String name, String email, String address, double total, List<CartItem> cart) {
        
        String MAC_PATH = "/Users/qonitaf/Projects/apache-tomcat-9.0.113/webapps/giftgenie/WEB-INF/orders.csv"; 

        File file = new File(MAC_PATH);

        System.out.println("📂 SAVING TO: " + MAC_PATH);

        boolean newFile = !file.exists();

        try (FileWriter fw = new FileWriter(file, true);
             BufferedWriter bw = new BufferedWriter(fw)) {

            if (newFile) {
                bw.write("timestamp,name,email,address,total,items");
                bw.newLine();
            }

            StringBuilder itemsStr = new StringBuilder();
            for (CartItem item : cart) {
                itemsStr.append(item.getProduct().getName())
                        .append("(x").append(item.getQty()).append(") | ");
            }

            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            bw.write(String.format("%s,%s,%s,%s,%.2f,%s", 
                timestamp,
                name.replace(",", " "),
                email.replace(",", " "),
                address.replace(",", " "),
                total,
                itemsStr.toString()
            ));
            bw.newLine();
            
            System.out.println("✅ SUCCESS! Order saved to Mac folder.");

        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("❌ ERROR: Could not save file. " + e.getMessage());
        }
    }

    // --- SERVLET METHODS ---

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        List<CartItem> cart = getCart(session);

        req.setAttribute("cart", cart);
        req.setAttribute("total", calcTotal(cart));
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        List<CartItem> cart = getCart(session);

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String address1 = req.getParameter("address1");
        String cardNumber = req.getParameter("cardNumber");
        String expiry = req.getParameter("expiry");
        String cvv = req.getParameter("cvv");

        req.setAttribute("name", name);
        req.setAttribute("email", email);
        req.setAttribute("address1", address1);
        req.setAttribute("cardNumber", cardNumber);
        req.setAttribute("expiry", expiry);
        req.setAttribute("cvv", cvv);

        if (cart == null || cart.isEmpty()) {
            req.setAttribute("cart", cart);
            req.setAttribute("total", 0.0);
            req.setAttribute("error", "Your cart is empty.");
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
            return;
        }

        if (isBlank(name) || !isEmailLike(email) || isBlank(address1)
                || !isCardLike(cardNumber) || !isExpiryLike(expiry) || !isCvvLike(cvv)) {
            req.setAttribute("cart", cart);
            req.setAttribute("total", calcTotal(cart));
            req.setAttribute("error", "Please fill in all fields correctly.");
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
            return;
        }

        // --- SUCCESS! ---
        double total = calcTotal(cart);

        saveOrderToCsv(name, email, address1, total, cart);

        session.setAttribute("lastItems", snapshotCart(cart));
        session.setAttribute("lastTotal", total);
        session.setAttribute("lastName", name.trim());
        session.setAttribute("lastEmail", email.trim());

        cart.clear();

        resp.sendRedirect("success.jsp");
    }
}