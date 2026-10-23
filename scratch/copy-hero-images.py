import os
import shutil

src_dir = r"C:\Users\PRIYA AC\.cursor\projects\c-Users-PRIYA-AC-Desktop-women-FightDFear\assets"
dests = [
    r"C:\Users\PRIYA AC\Desktop\women\FightDFear\src\main\resources\static\images",
    r"C:\Users\PRIYA AC\Desktop\women\FightDFear\src\main\webapp\images",
]
pairs = [
    ("hero_split_img.png", "hero_split_img.png"),
]
for dest in dests:
    os.makedirs(dest, exist_ok=True)
    for src_name, dest_name in pairs:
        src_path = os.path.join(src_dir, src_name)
        if not os.path.isfile(src_path):
            print("MISSING", src_path)
            continue
        out = os.path.join(dest, dest_name)
        shutil.copy2(src_path, out)
        print("COPIED", out, os.path.getsize(out))
