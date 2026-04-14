package entity;

import java.sql.Date;

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
    private int role;         // Tương ứng cột: Role (INT) - 1: Admin, 0: User

    public User() {
    }

    public User(int id, String user, String gender, String pass, String address, String email, String phone, String name, Date birthday, int role) {
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

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", user=" + user + ", gender=" + gender + ", pass=" + pass + ", address=" + address + ", email=" + email + ", phone=" + phone + ", name=" + name + ", birthday=" + birthday + ", role=" + role + '}';
    }
}