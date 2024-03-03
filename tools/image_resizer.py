import cv2
import os
from tkinter import filedialog
from tkinter import simpledialog
from tkinter import messagebox
from tkinter import Tk, Label, Canvas, Entry, Button
from PIL import Image, ImageTk

def crop_image(image_path, width, height):
    # Load the image using cv2
    image = cv2.imread(image_path)

    # Crop the image
    cropped_image = image[:height, :width]

    # Save the image
    output_dir = os.path.join("./tools/", 'output')
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, 'cropped_' + os.path.basename(image_path))
    cv2.imwrite(output_path, cropped_image)

    return output_path
def crop_image_with_percentage(image_path, width, height_percentage=0):
    # Load the image using cv2
    image = cv2.imread(image_path)

    # Calculate the amount to crop from the top and bottom based on the percentage
    height_to_crop = int(image.shape[0] * height_percentage / 100)
    cropped_image = image[height_to_crop:image.shape[0]-height_to_crop, :width]

    # Save the image
    output_dir = os.path.join("./tools/", 'output')
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, 'cropped_' + os.path.basename(image_path))
    cv2.imwrite(output_path, cropped_image)

    return output_path
def main():
    # Create a tkinter root window (hidden)
    root = Tk()

    # Set the window size
    window_width = 1024
    window_height = 700
    root.geometry(f"{window_width}x{window_height}")

    # Center the window
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    position_top = int(screen_height / 2 - window_height / 2-50)
    position_right = int(screen_width / 2 - window_width / 2)
    root.geometry("+{}+{}".format(position_right, position_top))

    # Ask the user to select an image
    image_path = filedialog.askopenfilename(title='Select an image', filetypes=[('Image files', '*.jpg *.png')])

    # Display the selected image in a fixed frame
    img = Image.open(image_path)
    x_original = img.width
    y_original = img.height
    x = 700
    y = int((x / img.width) * img.height)
    print(x, y)
    img = img.resize((x, y), Image.LANCZOS)  # Resize the image to fit the frame
    img = ImageTk.PhotoImage(img)
    panel = Canvas(root, width=x, height=y)
    panel.create_image(0, 0, anchor='nw', image=img)
    panel.image = img
    panel.pack()

    # Create input fields for width and height
    # Create input fields for width and height
    width_label = Label(root, text="Width:")
    width_label.pack()
    width_entry = Entry(root)
    width_entry.insert(0, str(x_original))  # Set default value to image width
    width_entry.pack()

    height_label = Label(root, text="Height:")
    height_label.pack()
    height_entry = Entry(root)
    height_entry.insert(0, str(y_original))  # Set default value to image height
    height_entry.pack()
    
    percentage_label = Label(root, text="Height Percentage:")
    percentage_label.pack()
    percentage_entry = Entry(root)
    percentage_entry.insert(0, "8")  # Set default value to 8%
    percentage_entry.pack()
    
    
    print(x_original, y_original)

    # Create a button to validate the inputs and crop the image
    def validate_and_crop():
        width = int(width_entry.get())
        height = int(height_entry.get())
        output_path = crop_image(image_path, width, height)
        messagebox.showinfo('Image Cropper', 'Image has been cropped and saved to ' + output_path)
    def validate_and_crop_percentage():
        width = x_original
        height_percentage = int(percentage_entry.get())
        output_path = crop_image_with_percentage(image_path,width, height_percentage)
        messagebox.showinfo('Image Cropper', 'Image has been cropped and saved to ' + output_path)
    button = Button(root, text='Crop Image', command=validate_and_crop)
    button_2 = Button(root, text='Crop Image with Percentage', command=validate_and_crop_percentage)
    button.pack()
    button_2.pack()

    root.mainloop()

if __name__ == '__main__':
    main()
