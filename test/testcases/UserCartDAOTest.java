package testcases;

import dao.order.UserCartDAO;
import entity.Product;
import org.junit.After;
import static org.junit.Assume.assumeTrue;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class UserCartDAOTest {

    private final UserCartDAO cartDao = new UserCartDAO();
    private int userA;
    private int userB;
    private Product product;

    @Before
    public void setUp() throws Exception {
        assumeTrue("DB local chưa sẵn sàng cho integration test", TestDbSupport.isDatabaseAvailable());
        String suffix = String.valueOf(System.nanoTime());
        userA = TestDbSupport.createTestUser(suffix + "-A");
        userB = TestDbSupport.createTestUser(suffix + "-B");
        product = TestDbSupport.createTestProduct(suffix, 10, 10);
    }

    @After
    public void tearDown() throws Exception {
        if (!TestDbSupport.isDatabaseAvailable()) {
            return;
        }
        if (userA > 0) {
            TestDbSupport.cleanupUser(userA);
        }
        if (userB > 0) {
            TestDbSupport.cleanupUser(userB);
        }
        if (product != null) {
            TestDbSupport.cleanupProduct(product.getIdProduct());
        }
    }

    @Test
    public void addItemTwiceMergesQuantityIntoSingleRow() throws Exception {
        assertNull(cartDao.addItem(userA, product.getIdProduct(), 1));
        assertNull(cartDao.addItem(userA, product.getIdProduct(), 2));

        assertEquals(1, TestDbSupport.countUserCartRows(userA, product.getIdProduct()));
        assertEquals(3, TestDbSupport.getUserCartQuantity(userA, product.getIdProduct()));
    }

    @Test
    public void updateQuantityRejectsAvailableStockOverflow() throws Exception {
        assertNull(cartDao.addItem(userA, product.getIdProduct(), 2));
        assertNull(cartDao.updateItem(userA, product.getIdProduct(), 4));
        assertEquals(4, TestDbSupport.getUserCartQuantity(userA, product.getIdProduct()));

        String error = cartDao.updateItem(userA, product.getIdProduct(), 11);
        assertNotNull(error);
        assertEquals(4, TestDbSupport.getUserCartQuantity(userA, product.getIdProduct()));
    }

    @Test
    public void removeItemDeletesRow() throws Exception {
        assertNull(cartDao.addItem(userA, product.getIdProduct(), 1));
        cartDao.removeItem(userA, product.getIdProduct());
        assertEquals(0, TestDbSupport.countUserCartRows(userA, product.getIdProduct()));
    }

    @Test
    public void reservationCanBeCreatedAndReleasedWhenLowStockIsFive() throws Exception {
        Product lowStock = TestDbSupport.getProduct(product.getIdProduct());
        lowStock.setCurrentQuantity(5);
        assertTrue(new dao.product.ProductAdminDAO().updateProduct(lowStock));

        assertNull(cartDao.addItem(userA, product.getIdProduct(), 1));
        assertNull(cartDao.reserveLowStockItems(userA));
        assertTrue(TestDbSupport.isReserved(userA, product.getIdProduct()));
        assertTrue(TestDbSupport.hasExpiresAt(userA, product.getIdProduct()));

        cartDao.releaseReservations(userA);
        assertFalse(TestDbSupport.isReserved(userA, product.getIdProduct()));
        assertFalse(TestDbSupport.hasExpiresAt(userA, product.getIdProduct()));
    }

    @Test
    public void cartsDoNotLeakAcrossUsers() throws Exception {
        assertNull(cartDao.addItem(userA, product.getIdProduct(), 1));
        assertEquals(1, TestDbSupport.getUserCartQuantity(userA, product.getIdProduct()));
        assertEquals(0, TestDbSupport.getUserCartQuantity(userB, product.getIdProduct()));
        assertTrue(cartDao.getCartItems(userB).isEmpty());
    }
}
