package entity;

import java.sql.Timestamp;

public class ContactMessage {
    private int contactId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String subject;
    private String messageContent;
    private Timestamp sentDate;
    private String status; // 'NEW' | 'READ' | 'REPLIED'
    private String adminNotes;

    public ContactMessage() {}

    public int getContactId() { return contactId; }
    public void setContactId(int contactId) { this.contactId = contactId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getMessageContent() { return messageContent; }
    public void setMessageContent(String messageContent) { this.messageContent = messageContent; }

    public Timestamp getSentDate() { return sentDate; }
    public void setSentDate(Timestamp sentDate) { this.sentDate = sentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminNotes() { return adminNotes; }
    public void setAdminNotes(String adminNotes) { this.adminNotes = adminNotes; }
}
