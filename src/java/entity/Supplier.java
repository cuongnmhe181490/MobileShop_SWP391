package entity;

public class Supplier {
    private String idSupplier;
    private String name;
    private String address;
    private String email;
    private String phoneNumber;
    private String logoPath;

    public Supplier() {
    }

    public Supplier(String idSupplier, String name, String address, String email, String phoneNumber, String logoPath) {
        this.idSupplier = idSupplier;
        this.name = name;
        this.address = address;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.logoPath = logoPath;
    }

    public String getIdSupplier() {
        return idSupplier;
    }

    public void setIdSupplier(String idSupplier) {
        this.idSupplier = idSupplier;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getLogoPath() {
        return logoPath;
    }

    public void setLogoPath(String logoPath) {
        this.logoPath = logoPath;
    }

    @Override
    public String toString() {
        return "Supplier{" + "idSupplier=" + idSupplier + ", name=" + name + ", address=" + address + ", email=" + email + ", phoneNumber=" + phoneNumber + ", logoPath=" + logoPath + '}';
    }
}

