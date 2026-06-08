from PIL import Image, ImageDraw
import math

size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

draw.rounded_rectangle([0, 0, size, size], radius=200, fill='#12102a')

cx, cy = 512, 480
scale = 3.2
points = []
for t in range(0, 360):
    rad = math.radians(t)
    x = cx + scale * 40 * (16 * math.sin(rad)**3)
    y = cy - scale * 40 * (13*math.cos(rad) - 5*math.cos(2*rad) - 2*math.cos(3*rad) - math.cos(4*rad))
    points.append((x, y))
draw.polygon(points, fill='#FF6B9D')

plane_x, plane_y = 512, 490
draw.ellipse([plane_x-140, plane_y-45, plane_x+140, plane_y+45], fill='white')
draw.polygon([(plane_x+100, plane_y), (plane_x+170, plane_y-20), (plane_x+180, plane_y), (plane_x+170, plane_y+20)], fill='white')
draw.polygon([(plane_x-60, plane_y-45), (plane_x-160, plane_y-130), (plane_x-200, plane_y-120), (plane_x-120, plane_y-45)], fill='white')

img.save('assets/icon.png')
print('Icon created!')