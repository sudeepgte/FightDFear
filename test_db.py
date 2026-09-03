import pymysql

try:
    conn = pymysql.connect(host='localhost', user='root', password='root', database='womenbesafe')
    cursor = conn.cursor(pymysql.cursors.DictCursor)
    cursor.execute("SELECT id, full_name, profile_photo FROM user WHERE full_name IN ('Prakruthi', 'Aasif khan', 'varu1', 'varu')")
    for row in cursor.fetchall():
        print(f"{row['full_name']} -> {row['profile_photo']}")
    conn.close()
except Exception as e:
    print(f"Error: {e}")
