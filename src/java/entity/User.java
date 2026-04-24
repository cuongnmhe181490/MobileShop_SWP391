package entity;

import java.sql.Date;
import java.sql.Timestamp;


/**
 * 
 */
public class User {
    private int id;           // Tương ứng cột: UserId (INT)
    private String user;      // Tương ứng cột: Username (NVARCHAR)
    private String gender;    // Tương ứng cột: Gender (NVARCHAR)
    private String pass;      // Tương ứng cột: Password (NVARCHAR)
    private String address;   // Tương ứng cột: Address (NVARCHAR)
    private String email;     // Tương ứng cột: Email (VARCHAR)
    private String phone;     // Tương ứng cột: PhoneNumber (VARCHAR)
    private String name;      // Tương ứng cột: FullName (NVARCHAR)
    private Date birthday;    // Tương ứng cột: Birthday (DATE)
    private Role role;         
    private String resetToken;
    private Date resetTokenExpiry;
    private String status;
    private java.sql.Timestamp createdDate; 
    private String lockReason;

    public User() {
    }

    public User(int id, String user, String gender, String pass, String address, String email, String phone, String name, Date birthday, Role role) {
        this.id = id;
        this.user = user;
        this.gender = gender;
        this.pass = pass;
        this.address = address;
        this.email = email;
        this.phone = phone;
        this.name = name;
        this.birthday = birthday;
        this.role = role;
        this.status = status;
        this.createdDate = createdDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
    
    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Date getResetTokenExpiry() {
        return resetTokenExpiry;
    }

    public java.sql.Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(java.sql.Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public void setResetTokenExpiry(Date resetTokenExpiry) {
        this.resetTokenExpiry = resetTokenExpiry;
    }
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
    public String getLockReason() {
        return lockReason; 
    }
    
    public void setLockReason(String lockReason) { 
        this.lockReason = lockReason; 
    }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", user=" + user + ", gender=" + gender + ", pass=" + pass + ", address=" + address + ", email=" + email + ", phone=" + phone + ", name=" + name + ", birthday=" + birthday + ", role=" + role + '}';
    }
}