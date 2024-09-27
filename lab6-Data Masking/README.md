# Data Masking

Data masking is a way to hide sensitive information, like credit card numbers or social security numbers, so that it can't be seen by everyone. It helps keep your data safe while still allowing people to use it for tasks like testing or reporting.

## How It Works

- **Hides Sensitive Data**: Instead of showing the real data, it shows a fake version. For example, "1234-5678-9012-3456" might be shown as "XXXX-XXXX-XXXX-3456."
  
- **Controls Access**: Only certain users can see the actual data based on their job roles. For instance, a manager might see the real numbers, but a developer sees the masked ones.

## Why Use It?

- **Safety**: Protects sensitive information from unauthorized access.
- **Testing**: Developers can work with data that looks real but isn’t.
- **Sharing**: When you share data with partners, you don’t expose sensitive details.

## Types of Data Masking

### 1. Static Data Masking (SDM)
- **Description**: This method creates a copy of the original data with sensitive information replaced by masked values.
- **Use Case**: Useful for non-production environments like development and testing, where real data isn't needed.

### 2. Dynamic Data Masking (DDM)
- **Description**: Sensitive data is masked in real-time when users access it, based on their roles.
- **Use Case**: Ideal for environments where data is shared among users but not everyone should see the actual values.

## Row Data Masking

- **Description**: Row data masking involves masking or hiding entire rows of data based on certain criteria, such as user roles or access levels.

### How It Works
- When a user queries the database, the system determines if the user has permission to view specific rows. If not, those rows are either masked or completely hidden.

### Use Case
- Ideal for scenarios where sensitive data exists in the same table as non-sensitive data. For instance, in a customer database, you might want to hide rows for customers who have opted out of data sharing.

### Example
- An employee with limited access might see only some rows of the customer list, while a manager could view all the rows, including sensitive customer information.

## Column Data Masking

- **Description**: Column data masking specifically targets sensitive columns within a table. Instead of hiding entire rows, it obfuscates specific columns based on user permissions.

### How It Works
- When users query a table, the data in certain columns is replaced with masked values for users without proper access, while others can see the real data.

### Use Case
- Useful when certain columns contain sensitive information (like social security numbers or credit card details) but other columns are not sensitive (like names or addresses).

### Example
- In a payroll database, an HR manager might see actual salary figures, while a regular employee might see those figures masked as “XXXX.”

## Summary

- **Row Data Masking**: Hides entire rows based on user permissions, ensuring that users only see the rows they are authorized to access.

- **Column Data Masking**: Masks specific columns of data within rows, allowing users to see non-sensitive information while protecting sensitive fields.

Both techniques help organizations maintain data privacy and comply with regulations while still allowing for data use in analytics, testing, and reporting.
