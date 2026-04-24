package dao;

import entity.ContactMessage;
import config.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {

    public boolean insertMessage(ContactMessage m) throws Exception {
        String sql = "INSERT INTO ContactMessages (FullName, Email, PhoneNumber, [Subject], MessageContent, [Status]) " +
                     "VALUES (?, ?, ?, ?, ?, 'NEW')";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, m.getFullName());
            ps.setString(2, m.getEmail());
            ps.setString(3, m.getPhoneNumber());
            ps.setString(4, m.getSubject());
            ps.setString(5, m.getMessageContent());
            return ps.executeUpdate() > 0;
        }
    }

    public List<ContactMessage> getFiltered(String status, String subject, int page, int pageSize) throws Exception {
        List<ContactMessage> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ContactMessages WHERE 1=1");
        if (status != null && !status.isEmpty()) sql.append(" AND [Status] = ?");
        if (subject != null && !subject.isEmpty()) sql.append(" AND [Subject] = ?");
        sql.append(" ORDER BY SentDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int i = 1;
            if (status != null && !status.isEmpty()) ps.setString(i++, status);
            if (subject != null && !subject.isEmpty()) ps.setString(i++, subject);
            ps.setInt(i++, (page - 1) * pageSize);
            ps.setInt(i++, pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public int countFiltered(String status, String subject) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ContactMessages WHERE 1=1");
        if (status != null && !status.isEmpty()) sql.append(" AND [Status] = ?");
        if (subject != null && !subject.isEmpty()) sql.append(" AND [Subject] = ?");
        
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int i = 1;
            if (status != null && !status.isEmpty()) ps.setString(i++, status);
            if (subject != null && !subject.isEmpty()) ps.setString(i++, subject);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<ContactMessage> getAll(int page, int pageSize) throws Exception {
        return getFiltered(null, null, page, pageSize);
    }



    public boolean updateStatus(int contactId, String status, String adminNotes) throws Exception {
        String sql = "UPDATE ContactMessages SET [Status] = ?, AdminNotes = ? WHERE ContactId = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, adminNotes);
            ps.setInt(3, contactId);
            return ps.executeUpdate() > 0;
        }
    }

    private ContactMessage mapRow(ResultSet rs) throws SQLException {
        ContactMessage m = new ContactMessage();
        m.setContactId(rs.getInt("ContactId"));
        m.setFullName(rs.getString("FullName"));
        m.setEmail(rs.getString("Email"));
        m.setPhoneNumber(rs.getString("PhoneNumber"));
        m.setSubject(rs.getString("Subject"));
        m.setMessageContent(rs.getString("MessageContent"));
        m.setSentDate(rs.getTimestamp("SentDate"));
        m.setStatus(rs.getString("Status"));
        m.setAdminNotes(rs.getString("AdminNotes"));
        return m;
    }
}
