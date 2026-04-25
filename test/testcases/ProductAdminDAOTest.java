package testcases;

import dao.product.ProductAdminDAO;
import entity.Product;
import org.junit.After;
import static org.junit.Assume.assumeTrue;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ProductAdminDAOTest {

    private final ProductAdminDAO dao = new ProductAdminDAO();
    private String createdProductId;

    @Before
    public void setUp() {
        assumeTrue("DB local chưa sẵn sàng cho integration test", TestDbSupport.isDatabaseAvailable());
    }

    @After
    public void tearDown() throws Exception {
        if (createdProductId != null) {
            TestDbSupport.cleanupProduct(createdProductId);
        }
    }

    @Test
    public void newProductUsesNextNumericIdAndAppearsAtAscendingEnd() throws Exception {
        String nextId = dao.getNextProductId();
        Product product = TestDbSupport.createTestProduct(String.valueOf(System.nanoTime()), 10, 10);
        createdProductId = product.getIdProduct();

        assertEquals(nextId, createdProductId);
        assertTrue(createdProductId.matches("\\d{4,}"));
        assertEquals(Integer.parseInt(createdProductId), TestDbSupport.getAscendingLastProductNumericId());
    }

    @Test
    public void restockIncreasesOriginalAndCurrentQuantities() throws Exception {
        Product product = TestDbSupport.createTestProduct(String.valueOf(System.nanoTime()), 10, 0);
        createdProductId = product.getIdProduct();

        product.setCurrentQuantity(7);
        assertTrue(dao.updateProduct(product));

        Product updated = dao.getProductByID(createdProductId);
        assertEquals(17, updated.getOriginalQuantity());
        assertEquals(7, updated.getCurrentQuantity());
    }

    @Test
    public void reducingCurrentQuantityDoesNotIncreaseOriginalQuantity() throws Exception {
        Product product = TestDbSupport.createTestProduct(String.valueOf(System.nanoTime()), 17, 7);
        createdProductId = product.getIdProduct();

        product.setCurrentQuantity(3);
        assertTrue(dao.updateProduct(product));

        Product updated = dao.getProductByID(createdProductId);
        assertEquals(17, updated.getOriginalQuantity());
        assertEquals(3, updated.getCurrentQuantity());
    }
}
