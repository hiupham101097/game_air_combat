import os
from PIL import Image

def process_image(filepath):
    try:
        img = Image.open(filepath).convert("RGBA")
        datas = img.getdata()

        newData = []
        for item in datas:
            # Change all near black (also white if there is a white background but usually black) to transparent
            # Let's assume background is pure black or very dark
            if item[0] < 15 and item[1] < 15 and item[2] < 15:
                newData.append((255, 255, 255, 0))
            else:
                newData.append(item)

        img.putdata(newData)
        
        # Now crop to bounding box
        bbox = img.getbbox()
        if bbox:
            img = img.crop(bbox)
        
        img.save(filepath, "PNG")
        print(f"Processed: {filepath}")
    except Exception as e:
        print(f"Error processing {filepath}: {e}")

assets_dir = "assets"
for filename in os.listdir(assets_dir):
    if filename.endswith(".png") and (filename.startswith("ship_") or filename.startswith("boss_") or filename.startswith("equip_")):
        if filename != "ship_2.png": # skip if it's already a good asset
            process_image(os.path.join(assets_dir, filename))

process_image(os.path.join(assets_dir, "drone.png"))

print("Done processing images.")
