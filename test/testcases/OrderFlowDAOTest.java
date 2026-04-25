package testcases;

import dao.order.OrderDAO;
import dao.order.UserCartDAO;
import entity.CartItem;
import entity.Product;
import java.util.List;
import org.junit.After;
import static org.junit.Assume.assumeTrue;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class OrderFlowDAOTest {

    private final UserCartDAO cartDao = new UserCartDAO();
    private final OrderDAO orderDao = new OrderDAO();
    private int userId;
    private Product productA;
    private Product productB;
    private Integer orderIdToCleanup;

    @Before
    public void setUp() throws Exception {
        assumeTrue("DB local chưa sẵn sàng cho integration test", TestDbSupport.isDatabaseAvailable());
        String suffix = String.valueOf(System.nanoTime());
        userId = TestDbSupport.createTestUser(suffix);
        productA = TestDbSupport.createTestProduct(suffix + "-A", 10, 10);
        productB = TestDbSupport.createTestProduct(suffix + "-B", 5, 5);
    }

    @After
    public void tearDown() throws Exception {
        if (!TestDbSupport.isDatabaseAvailable()) {
            return;
        }
        if (orderIdToCleanup != null) {
            TestDbSupport.deleteOrder(orderIdToCleanup);
        }
        if (userId > 0) {
            TestDbSupport.cleanupUser(userId);
        }
        if (productA != null) {
            TestDbSupport.cleanupProduct(productA.getIdProduct());
        }
        if (productB != null) {
            TestDbSupport.cleanupProduct(productB.getIdProduct());
        }
    }

    @Test
    public void placeOrderSingleProductCreatesOrderReducesStockAndClearsCart() throws Exception {
        assertNull(cartDao.addItem(userId, productA.getIdProduct(), 1));
        List<CartItem> items = cartDao.getCartItems(userId);
        orderIdToCleanup = orderDao.createOrder(userId, "TEST-CODEX", "0912345678", "Test Address", TestDbSupport.computeTotal(items), items);

        assertTrue(orderIdToCleanup > 0);
        assertEquals(1, TestDbSupport.countOrderDetails(orderIdToCleanup));
        assertTrue(TestDbSupport.isDeliveringStatus(TestDbSupport.getOrderStatus(orderIdToCleanup)));
        assertEquals(0, TestDbSupport.getUserCartQuantity(userId, productA.getIdProduct()));
        assertEquals(9, TestDbSupport.getProduct(productA.getIdProduct()).getCurrentQuantity());
    }

    @Test
    public void lowStockQuantityFiveTriggersReservation() throws Exception {
        assertNull(cartDao.addItem(userId, productB.getIdProduct(), 1));
        assertNull(cartDao.reserveLowStockItems(userId));
        assertTrue(TestDbSupport.isReserved(userId, productB.getIdProduct()));
        assertTrue(TestDbSupport.hasExpiresAt(userId, productB.getIdProduct()));
    }

    @Test
    public void cancelingDeliveringOrderRestoresCurrentQuantity() throws Exception {
        assertNull(cartDao.addItem(userId, productA.getIdProduct(), 2));
        List<CartItem> items = cartDao.getCartItems(userId);
        orderIdToCleanup = orderDao.createOrder(userId, "TEST-CODEX", "0912345678", "Test Address", TestDbSupport.computeTotal(items), items);

        assertEquals(8, TestDbSupport.getProduct(productA.getIdProduct()).getCurrentQuantity());
        assertTrue(orderDao.updateOrderStatus(orderIdToCleanup, OrderDAO.STATUS_CANCELED));
        assertEquals(10, TestDbSupport.getProduct(productA.getIdProduct()).getCurrentQuantity());
    }

    @Test
    public void placeOrderWithMultipleProductsCreatesMultipleOrderDetails() throws Exception {
        assertNull(cartDao.addItem(userId, productA.getIdProduct(), 1));
        assertNull(cartDao.addItem(userId, productB.getIdProduct(), 2));
        List<CartItem> items = cartDao.getCartItems(userId);
        orderIdToCleanup = orderDao.createOrder(userId, "TEST-CODEX", "0912345678", "Test Address", TestDbSupport.computeTotal(items), items);

        assertEquals(2, TestDbSupport.countOrderDetails(orderIdToCleanup));
        assertEquals(9, TestDbSupport.getProduct(productA.getIdProduct()).getCurrentQuantity());
        assertEquals(3, TestDbSupport.getProduct(productB.getIdProduct()).getCurrentQuantity());
    }
}
