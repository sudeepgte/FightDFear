package in.sp.main.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.WomenProduct;
import in.sp.main.Repository.WomenProductRepository;

@Service
public class AtomicStockService {

    @Autowired
    private WomenProductRepository productRepository;

    @Transactional
    public WomenProduct decrementStock(Long productId, int quantity) {
        if (productId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Product ID is required.");
        }
        if (quantity < 1) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid quantity: must be at least 1.");
        }

        WomenProduct product = productRepository.findByIdForUpdate(productId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Product not found."));

        if (Boolean.TRUE.equals(product.getDeleted()) || !Boolean.TRUE.equals(product.getActive())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Product '" + product.getName() + "' is not available.");
        }

        int currentStock = product.getStock() == null ? 0 : product.getStock();
        if (currentStock <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Product '" + product.getName() + "' is out of stock.");
        }
        if (quantity > currentStock) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Only " + currentStock + " unit(s) available for '" + product.getName() + "'.");
        }

        product.setStock(currentStock - quantity);
        return productRepository.save(product);
    }
}
