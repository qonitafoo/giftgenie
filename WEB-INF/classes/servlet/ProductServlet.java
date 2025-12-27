package servlet;

import model.Product;
import model.ProductRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        int id;

        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            resp.sendError(400, "Invalid product id");
            return;
        }

        String jsonPath = getServletContext().getRealPath("/products.json");
        Product p = ProductRepository.findById(jsonPath, id);

        if (p == null) {
            resp.sendError(404, "Product not found");
            return;
        }

        req.setAttribute("product", p);
        req.getRequestDispatcher("/product.jsp").forward(req, resp);
    }
}