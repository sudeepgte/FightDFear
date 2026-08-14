import mysql.connector
from datetime import date

# Database connection configuration
config = {
    'user': 'root',
    'password': 'root',
    'host': 'localhost',
    'database': 'womenbesafe',
    'raise_on_errors': True
}

try:
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)

    # 1. Check if user "Syed" exists
    cursor.execute("SELECT id FROM user WHERE full_name LIKE '%Syed%'")
    user = cursor.fetchone()

    if not user:
        print("Syed not found. Creating user...")
        cursor.execute("INSERT INTO user (full_name, email, phone_number, password, verification_status) VALUES (%s, %s, %s, %s, %s)", 
                       ("Syed Mohammad", "syed.martial@example.com", "9876543210", "password123", "VERIFIED"))
        user_id = cursor.lastrowid
    else:
        user_id = user['id']
        print(f"Found Syed with ID: {user_id}")

    # 2. Get a Martial Arts Center
    cursor.execute("SELECT id FROM martial_arts_center LIMIT 1")
    center = cursor.fetchone()
    if not center:
        print("No martial arts center found. Cannot proceed.")
        exit()
    center_id = center['id']

    # 3. Get a Batch
    cursor.execute("SELECT id FROM martial_arts_batch LIMIT 1")
    batch = cursor.fetchone()
    if not batch:
        print("No batch found. Creating a demo batch...")
        cursor.execute("INSERT INTO martial_arts_batch (name, style, center_id, status, batch_type) VALUES (%s, %s, %s, %s, %s)",
                       ("Morning Warriors", "Karate", center_id, "Active", "Offline"))
        batch_id = cursor.lastrowid
    else:
        batch_id = batch['id']

    # 4. Ensure Syed is enrolled in this batch
    cursor.execute("SELECT id FROM enrollment WHERE user_id = %s AND batch_id = %s", (user_id, batch_id))
    enrollment = cursor.fetchone()
    if not enrollment:
        print("Enrolling Syed in batch...")
        cursor.execute("INSERT INTO enrollment (user_id, center_id, batch_id, status, payment_status, full_name, email) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                       (user_id, center_id, batch_id, 'COMPLETED', 'PAID', "Syed Mohammad", "syed.martial@example.com"))

    # 5. Mark Attendance for Today
    today = date.today().isoformat()
    cursor.execute("SELECT id FROM attendance WHERE user_id = %s AND attendance_date = %s", (user_id, today))
    att = cursor.fetchone()
    
    if not att:
        print(f"Marking Syed as PRESENT for {today}...")
        cursor.execute("INSERT INTO attendance (user_id, batch_id, attendance_date, attendance_status, mode) VALUES (%s, %s, %s, %s, %s)",
                       (user_id, batch_id, today, 'PRESENT', 'OFFLINE'))
    else:
        print(f"Syed already has attendance record for {today}. Updating to PRESENT...")
        cursor.execute("UPDATE attendance SET attendance_status = 'PRESENT' WHERE id = %s", (att['id'],))

    conn.commit()
    print("Operation completed successfully.")

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    if 'conn' in locals() and conn.is_connected():
        cursor.close()
        conn.close()
